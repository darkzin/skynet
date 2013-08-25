# -*- coding: utf-8 -*-
class AssignmentsController < ApplicationController
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

    @assignment.file_infos.build
    # unless params[:subject_id].nil?
    #   @subject = Subject.find(params[:subject_id])
    # else
    #   @subject = Subject.last
    # end

    @subjects = @course.subjects.all.to_a
    @subjects.delete @subject

    redirect_to courses_path if @subject.nil?

    @problems = @subject.problems.all

    # unless params[:problem_id].nil?
    #   @problem = @subject.problems.find(params[:problem_id])
    # else
    #   @problem = @subject.problems.last
    # end

    @problems.delete @problem

  end

  def create
    @problem = Problem.find(params.permit(:problem_id)[:problem_id])
    @assignment = @problem.assignments.new
    file_infos = params.require(:assignment).permit(:file_infos_attributes => [])[:file_infos_attributes]
    file_infos.each do |file|
      @assignment.file_infos.new(name: file.original_filename, extension: File.extname(file.original_filename), file: file)
    end

    if @assignment.save
      redirect_to @assignment, success: "과제가 성공적으로 제출되었습니다."
    else
      render :new, error: "과제 제출에 실패하였습니다." + @assignment.errors.full_messages.join(" ")
    end

  end
end
