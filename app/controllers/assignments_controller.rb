# -*- coding: utf-8 -*-
class AssignmentsController < ApplicationController
  def index
    @assignments = Assignment.all
  end

  def show
    @assignment = Assignment.find(params[:id])
    @problem = Problem.find(@assignment.problem_id)
    @subject = Subject.find(@problem.subject_id)
  end

  def new
    @assignment = Assignment.new
    @subjects = Subject.all
    @subject = Subject.find(params[:subject_id])
    @problems = @subject.problems.all
    @problem = @subject.problems.find(params[:problem_id])
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
