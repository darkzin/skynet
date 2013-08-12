# -*- coding: utf-8 -*-
class AssignmentsController < ApplicationController
  def index
    if student_signed_in?
      @assignments = current_student.assignments.all
    else
      @assignments = Assignment.all
    end

    @subjects = Subject.all

    unless params[:subject_id].nil?
      @subject = Subject.find(params[:subject_id])
    else
      @subject = Subject.first
    end

    @problems = @subject.problems.all

    unless params[:problem_id].nil? || @subject.nil?
      @problem = @subject.problems.find(params[:problem_id])
    else
      @problem = @subject.problems.first
    end

  end

  def show
    @assignment = Assignment.find(params[:id])
    @problem = Problem.find(@assignment.problem_id)
    @subject = Subject.find(@problem.subject_id)
  end

  def new
    @assignment = Assignment.new
    @subjects = Subject.all

    unless params[:subject_id].nil?
      @subject = Subject.find(params[:subject_id])
    else
      @subject = Subject.last
    end

    @subjects.delete @subject

    redirect_to courses_path if @subject.nil?

    @problems = @subject.problems.all

    unless params[:problem_id].nil?
      @problem = @subject.problems.find(params[:problem_id])
    else
      @problem = @subject.problems.last
    end

    @problems.delete @problem

  end

  def create
    @assignment = Assignment.new(params.require(:assignment).permit!)

    if @assignment.save
      redirect_to @assignment, notice: "성공적으로 세출되었습니다."
    else
      render :new
    end

  end
end
