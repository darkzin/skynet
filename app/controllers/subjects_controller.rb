# -*- coding: utf-8 -*-
class SubjectsController < ApplicationController
  def index
    @subjects = Subject.all
  end

  def show
    @subjects = Subject.all
    @subject = Subject.find(params[:id])
    @files = @subject.file_infos.all
    @problems = @subject.problems.all
  end

  def new
    @course = Course.find(params.permit(:course_id)[:course_id])
    @subject = @course.subjects.new
    @subject.deadlines.build
    @subject.file_infos.build
  end

  def create
    @course = Course.find(params.permit(:course_id)[:course_id])
    @subject = @course.subjects.new(params.require(:subject).permit(:name, :content, deadlines_attributes: [:start, :end, :penalty]))

    file_infos = params.require(:subject).permit(file_infos_attributes: [])[:file_infos_attributes]
    file_infos.each do |file|
      @subject.file_infos.new(name: file.original_filename, extension: File.extname(file.original_filename), file: file)
    end

    debugger

    if @subject.save
      redirect_to new_subject_problem_path(@subject), success: "과제가 성공적으로 저장되었습니다. 이제 문제를 만들어주세요."
    else
      render :new, error: "과제 저장에 실패했습니다. 다시 저장해주세요." + @subject.errors.to_s
    end
  end

  def edit
    @subject = Subject.find(params[:id])
    @files = @subject.file_infos.all
    @problems = @subject.problems.all
  end

  def update
    @subject = Subject.find(params[:id])

    if @subject.update_attributes(params[:subject])
      redirect_to @subject, notice: "성공적으로 반영되었습니다."
    else
      render edit
    end
  end

end
