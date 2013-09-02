# -*- coding: utf-8 -*-
require 'open3'

class AssignmentsController < ApplicationController
  #before_action :permit_user!, only: [:destroy,

  def index
    @problem = Problem.find(params.permit(:problem_id)[:problem_id])
    @assignments = @problem.assignments.all.to_a
    @subject = @problem.subject
    @course = @subject.course

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
    @assignment = @problem.assignments.new
    # @problem.criterions.each do |criterion|
    #   @assignment.scores.new(criterion_id: criterion.id, score: 0)
    # end
    file_infos = params.require(:assignment).permit(:file_infos_attributes => [])[:file_infos_attributes]
    file_infos.each do |file|
      @assignment.file_infos.new(name: file.original_filename, extension: File.extname(file.original_filename), file: file)
    end

    if @assignment.save
      assignment_arguments = ""
      @assignment.file_infos.each { |file_info| assignment_arguments += file_info.file.path + " " }
      stdin, stdout, stderr = Open3.popen3(". #{@problem.script.path} #{assignment_arguments}")
      debugger
      # @assignment.scores.each_with_index do |index, score|
      #   unless stdout[index].nil?
      #     score = stdout[index].split("\t")[0].to_i
      #   else
      #     score = 0
      #   end
      # end
      @assignment.compile_message = stdout.readlines.join
      @assignment.save

      redirect_to [@problem, @assignment], flash: { success: "과제가 성공적으로 제출되었습니다." }
    else
      redirect_to new_problem_assignment_path(@problem), flash: { error: "과제 제출에 실패하였습니다." + @assignment.errors.full_messages.join(" ") }
    end

  end
end
