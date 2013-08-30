# -*- coding: utf-8 -*-
class ProblemsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @subject = Subject.find(params.permit(:subject_id)[:subject_id])
    @course = @subject.course
    @problem = @subject.problems.new
    @problem.criterions.build
    @problem.build_script
    @problem.file_infos.build
  end

  def edit
  end

  def update
  end

  def create
    @subject = Subject.find(params.permit(:subject_id)[:subject_id])
    @problem = @subject.problems.new(params.require(:problem).permit(:name, :content, :input_data, :model_paper, :compile_command, criterions_attributes: [:name, :score], script_attributes: [:file]))

    file_infos = params.require(:problem).permit(:file_infos_attributes => [])[:file_infos_attributes]
    file_infos.each do |file|
      @problem.file_infos.new(name: file.original_filename, extension: File.extname(file.original_filename), file: file)
    end

    if @problem.save
      redirect_to new_subject_problem_path(params[:subject_id]), flash: { success: "문제를 성공적으로 저장했습니다. 다음 문제를 입력해주세요."}
    else
      redirect_to new_subject_problem_path(params[:subject_id]), flash: { error: "문제 저장에 실패하였습니다. " + @problem.errors.full_messages.join(" ")}
    end
  end

  def destroy
    @subject = Subject.find(params.permit(:subject_id)[:subject_id])
    @course = @subject.course
    @problem = @subject.problems.find(params.permit(:id)[:id])
    @problem.destroy

    redirect_to [@course, @subject]
  end


end
