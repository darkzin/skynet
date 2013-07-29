# -*- coding: utf-8 -*-
class ProblemsController < ApplicationController
  def index
  end

  def new
  end

  def edit
  end

  def update
  end

  def create
    @problem = Problem.new(params.require(:problem).permit!)
p params[:problem_id]
    if @problem.save
      redirect_to subject_path(@problem.subject_id), notice: "문제가 성공적으로 저장되었습니다."
    else
      redirect_to new_subject_problem_path(params[:subject_id]), notice: "저장에 실패하였습니다. 다시 시도 해주세요"
    end
  end

  def delete
  end

  def show
  end
end
