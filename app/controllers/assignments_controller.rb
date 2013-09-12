# -*- coding: utf-8 -*-
require 'open3'

class AssignmentsController < ApplicationController
  before_action :permit_user!
  before_action :permit_student!, only: [:new]
  def index
    @problem = Problem.find(params.permit(:problem_id)[:problem_id])

    if can_i_manage_this_course?
      @assignments = @problem.assignments.all.to_a
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

        #puts "#{benchmark_command} bash #{File.basename(@problem.script.path)} #{assignment_arguments}"
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

        File.open("assignments/#{@assignment.id.to_s}/#{source_code}.grade") do |file|
          file.readlines.each_with_index do |line, index|
            if index > 0
              scores << line.split(',')[0].strip
            end
          end
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

  def destroy
    @assignment = Assignment.find(params.permit(:id)[:id])

    if @assignment.destroy
      redirect_to assignments_path, flash: { success: "과제 제출이 성공적으로 삭제되었습니다." }
    else
      redirect_to assignemtns_path, flash: { error: "과제 제출 삭제에 실패하였습니다." }
    end
  end

end
