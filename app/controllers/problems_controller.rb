# -*- coding: utf-8 -*-
class ProblemsController < ApplicationController
  def index
  end

  def new
    @subject = Subject.find(params.permit(:subject_id)[:subject_id])
  end

  def edit
  end

  def update
  end

  def create
    @problem = Problem.new(params.require(:problem).permit!)
    if @problem.save
      redirect_to new_subject_problem_path(params[:subject_id]), success: "문제를 성공적으로 저장했습니다. 다음 문제를 입력해주세요."
    else
      redirect_to new_subject_problem_path(params[:subject_id]), error: "저장에 실패하였습니다. 다시 시도 해주세요"
    end
  end

  def delete
  end

  def show
  end
end
