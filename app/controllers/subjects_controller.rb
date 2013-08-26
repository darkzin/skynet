# -*- coding: utf-8 -*-
class SubjectsController < ApplicationController
  def index
    @subjects = Subject.all
  end

  def show
    @course = Course.find(params.permit(:course_id)[:course_id])
    @subjects = @course.subjects.all

    @subjects.delete_if do |subject|
      subject.deadlines.each do |deadline|
        if deadline.start <= DateTime.now
          return false
        end
      end
      true
    end

    @subject = @course.subjects.find(params.permit(:id)[:id])
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

    uploaded_files = params.require(:subject).permit(file_infos_attributes: [])[:file_infos_attributes]
    uploaded_files.each do |file|
      debugger
      @subject.file_infos.new(name: file.original_filename, extension: File.extname(file.original_filename), file: file)
    end

    if @subject.save
      redirect_to new_subject_problem_path(@subject), success: "과제가 성공적으로 저장되었습니다. 이제 문제를 만들어주세요."
    else
      render :new, error: "과제 저장에 실패했습니다. " + @subject.errors.full_messages.join(" ")
    end
  end

  def edit
    @subject = Subject.find(params.permit(:id)[:id])
    @files = @subject.file_infos.all
    @problems = @subject.problems.all
  end

  def update
    @subject = Subject.find(params.permit(:id)[:id])

    if @subject.update_attributes(params.require(:subject).permit(:name, :content))
      redirect_to @subject, notice: "과제 내용이 성공적으로 수정되었습니다."
    else
      render edit, error: "과저 내용 수정에 실패하였습니다. " + @subject..errors.full_messages.join(" ")
    end
  end

end
