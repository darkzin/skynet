# -*- coding: utf-8 -*-
class ProblemsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @subject = Subject.find(params.permit(:subject_id)[:subject_id])
    @problem = @subject.problems.new
    @problem.criterions.build
    @problem.file_infos.build
  end

  def edit
  end

  def update
  end

  def create
    @problem = Problem.new(params.require(:problem).permit(:name, :content, :input_data, :model_paper, :compile_command))

    if @problem.save
      redirect_to new_subject_problem_path(params[:subject_id]), success: "문제를 성공적으로 저장했습니다. 다음 문제를 입력해주세요."
    else
      redirect_to new_subject_problem_path(params[:subject_id]), error: "문제 저장에 실패하였습니다. " + @problem.errors.full_messages.join(" ")
    end
  end

  def delete
  end


end
