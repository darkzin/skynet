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
  end

  def create
    @course = Course.new(params.permit(:course_id))
    @subject = @course.subjects.new(params.require(:subject).permit(:name, :content, :deadlines))
    file_infos = params.require(:subject).permit(:file_infos_attributes => [])[:file_infos_attributes]

    file_infos.each do |file|
      @subject.file_infos.new(name: file.original_filename, extension: File.extname(file.original_filename), file: file)
    end

    debugger

    @files

    if @subject.save
      redirect_to new_subject_problem_path(@subject), notice: "성공적으로 저장되었습니다."
    else
      render :new
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
