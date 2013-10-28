# -*- coding: utf-8 -*-
require 'open3'
require 'timeout'

class AssignmentsController < ApplicationController
  before_action :permit_user!
  #before_action :permit_student!, only: [:new]
  before_action :permit_professor!, only: [:destroy]
  def index
    @problem = Problem.find(params.permit(:problem_id)[:problem_id])
    if can_i_manage_this_course?
      #@problem = Problem.find_by_sql("SELECT * FROM assignments WHERE problem_id = :id", :id => params.permit(:problem_id)[:problem_id])
      if(params.permit(:start_date)[:start_date] != nil && params.permit(:end_date)[:end_date] != nil)
  @start_date = Time.parse(params.permit(:start_date)[:start_date]).utc
  @end_date = Time.parse(params.permit(:end_date)[:end_date]).utc
  @assignments = @problem.assignments.where(:created_at => @start_date..@end_date).order("created_at DESC").group("student_id").to_a
      else
        @assignments = @problem.assignments.find(:all, order: 'created_at desc', group: 'student_id').to_a
        #@assignments = @problem.assignments.find(:all, select: 'DISTINCT student_id').to_a
        #@assignments = @problem.assignments.all.to_a
      end
    else
      @assignments = @problem.assignments.where(student_id: current_student.id).to_a
    end

    @subject = @problem.subject
    @course = @subject.course

    @subjects = @course.subjects.all.to_a
    @subjects.delete @subject

    #redirect_to courses_path, notice: "과제가 없습니다. 새로 만들어 주세요.", if @subject.nil?

    @problems = @subject.problems.all.to_a
    @problems.delete @problem

    # if student_signed_in?
    #   @assignments = current_student.assignments.all
    # else
    #   @assignments = Assignment.all
    # end

    # @subjects = Subject.all

    # unless params[:subject_id].nil?
    #   @subject = Subject.find(params[:subject_id])
    # else
    #   @subject = Subject.first
    # end

    # @problems = @subject.problems.all

    # unless params[:problem_id].nil? || @subject.nil?
    #   @problem = @subject.problems.find(params[:problem_id])
    # else
    #   @problem = @subject.problems.first
    # end

  end

  def show
    @assignment = Assignment.find(params[:id])
    @problem = @assignment.problem
    @subject = @problem.subject
    @course = @subject.course
    @comments = @assignment.comments.all.to_a
    @comment = Comment.new
  end

  def new
    @problem = Problem.find(params.permit(:problem_id)[:problem_id])
    @assignment = @problem.assignments.new
    @subject = @problem.subject
    @course = @subject.course

    unless @subject.deadlines.where("start <= ?", DateTime.now).where("end >= ?", DateTime.now).any?
      redirect_to [@course, @subject], alert: "기한이 지난 문제는 제출할 수 없습니다."
    end

    @assignment.file_infos.build
    # unless params[:subject_id].nil?
    #   @subject = Subject.find(params[:subject_id])
    # else
    #   @subject = Subject.last
    # end


    @subjects = @course.subjects.all.to_a

    @subjects.delete_if do |subject|
      subject.deadlines.where("start <= ?", DateTime.now).where("end >= ?", DateTime.now).empty?
    end

    @subjects.delete @subject

    #redirect_to courses_path, notice: "과제가 없습니다. 새로 만들어 주세요.", if @subject.nil?

    @problems = @subject.problems.all
    @problems.delete @problem
  end

  def create
    @problem = Problem.find(params.permit(:problem_id)[:problem_id])
    @assignment = @problem.assignments.new(student_id: current_student.id)
    @subject = @problem.subject
    @course = @subject.course

    unless @subject.deadlines.where("start <= ?", DateTime.now).where("end >= ?", DateTime.now).any?
      redirect_to [@course, @subject], alert: "기한이 지난 문제는 제출할 수 없습니다."
    else

      # @problem.criterions.each do |criterion|
      #   @assignment.scores.new(criterion_id: criterion.id, score: 0)
      # end
      file_infos = params.require(:assignment).permit(:file_infos_attributes => [])[:file_infos_attributes]
      file_infos.each do |file|
        @assignment.file_infos.new(name: file.original_filename, extension: File.extname(file.original_filename), file: file)
      end

      if @assignment.save
        assignment_arguments = ""

        @assignment.file_infos.each do |file_info|
          assignment_arguments += "assignments/#{@assignment.id.to_s}/#{file_info.file.identifier} "
        end

        benchmark_command = "/usr/bin/time -v"

        Dir.chdir(File.dirname(@problem.script.path)) do
          stdin, stdout, stderr = Open3.popen3("#{benchmark_command} #{@problem.compile_command} ./#{File.basename(@problem.script.path)} #{assignment_arguments}")

          scores = []
          compile_message = ""
          result = ""
          lead_time = ""
          memory_usage = ""
          state = "error"

          puts "#{benchmark_command} #{@problem.compile_command} ./#{File.basename(@problem.script.path)} #{assignment_arguments}"

          stdout.readlines.each do |line|
            puts line
            if line.include? "Compilation succeeded."
              state = "success"
            else
              result += line + "\n"
            end
          end

          stderr.readlines.each do |line|
            if line.include? "User time (seconds):"
              lead_time = line.delete("User time (seconds):").strip

            elsif line.include? "Maximum resident set size (kbytes):"
              memory_usage = line.delete("Maximum resident set size (kbytes):").strip
            end
          end

          source_code = @assignment.file_infos.first.file.identifier

          # begin
          #   File.open("assignments/#{@assignment.id.to_s}/#{source_code}.grade") do |file|
          #     puts file.readlines.to_s
          #   end
          # rescue
          #   redirect_to new_problem_assignment_path(@problem), flash: { error: "컴파일 과정에 문제가 있습니다. 스크립트 파일을 확인하시기 바랍니다." }
          # end

          begin
            Timeout::timeout(10) do
              begin
                File.open("assignments/#{@assignment.id.to_s}/#{source_code}.grade") do |file|
                  file.readlines.each_with_index do |line, index|
                    if index > 0
                      scores << line.split(',')[0].strip
                    end
                  end
                end
              rescue
                retry
              end
            end
          rescue
            state = "compile failed"
            scores << "0"
          end

          total_score = 0

          @assignment.problem.criterions.each_with_index do |criterion, index|
            if scores[index]
              @assignment.scores.new(criterion_id: criterion.id, score: scores[index].to_i)
              total_score += scores[index].to_i
            else
              @assignment.scores.new(criterion_id: criterion.id, score: 0)
            end
          end

          @assignment.state = state
          @assignment.lead_time = lead_time
          @assignment.memory_usage = memory_usage
          @assignment.result = result
          @assignment.score = total_score
        end

        @assignment.save
        redirect_to [@problem, @assignment], flash: { success: "과제가 성공적으로 제출되었습니다." }
      else
        redirect_to new_problem_assignment_path(@problem), flash: { error: "과제 제출에 실패하였습니다." + @assignment.errors.full_messages.join(" ") }
      end
    end
  end

  def destroy
    @problem = Problem.find(params.permit(:problem_id)[:problem_id])
    @assignment = @problem.assignments.find(params.permit(:id)[:id])

    if @assignment.destroy
      redirect_to assignments_path, flash: { success: "과제 제출이 성공적으로 삭제되었습니다." }
    else
      redirect_to assignemtns_path, flash: { error: "과제 제출 삭제에 실패하였습니다." }
    end
  end

  def csv
    @course = Course.find(params[:id])
    @subject = @course.subjects.order(id: :asc).all.to_a
    result_column_names = ["학번", "이름"]
    problem_id_list = []
    @subject.each_with_index do |subject, s_index|
      problems = subject.problems.order(id: :asc).all.to_a
      problems.each_with_index do |problem, p_index|
        result_column_names << "#{s_index + 1}_#{p_index + 1}점수"
        problem_id_list << problem.id
      end
    end
    @students = @course.students.all.to_a
    c = CSV.generate do |csv|
      csv << result_column_names
      @students.each do |student|
        result = [student.student_number, student.name]
        problem_id_list.each do |problem_id|
          problem = Problem.find(problem_id)
          best_score_assignment = problem.assignments.where(student_id: student.id).order(score: :desc).first
          result << (best_score_assignment.nil? ? '0' : best_score_assignment.score.to_s)
        end # problem_id_list loop end.
        csv << result
      end # @students loop end.
      @problems = Problem.find(problem_id_list)
      result = ["만점", "만점"]
      @problems.each do |problem|
        criterions = problem.criterions.all.to_a
        if criterions.empty?
          score = 10
        else
          score = 0
          criterions.each do |criterion|
            score += (criterion.score.nil? ? 0 : criterion.score)
          end
        end # if end.
        result << score.to_s
      end
      csv << result
    end # csv loop end.
  end # csv action end.
end # class end.
