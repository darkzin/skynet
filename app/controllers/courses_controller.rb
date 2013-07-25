# -*- coding: utf-8 -*-
class CoursesController < ApplicationController

  def index
    @courses = Course.all
  end

  def show
   @course = Course.find(params[:id])

   if current_student.last_sign_in_at > 7.days.ago
     latest_date = 7.days.ago
   else
     latest_date = current_student.last_sign_in_at
   end

   @latest_notice = @course.notices.where("created_at >= ?", latest_date).order("created_at DESC")
   @outdate_notice = @course.notices.where("created_at < ?", latest_date).order("created_at DESC")

   @current_subjects = Subject.all
   @outdate_subjects = []

   @current_subjects.delete_if do |subject|

     if @subject.deadlines.where("from >= ? and to <= ?", Date.today, Date.today).empty?
       @outdate_subjects << subject
     else
       false
     end

   end

  end

  def new
    @course = Course.new
  end

  def create

    @course = current_professor.courses.new(params.require(:course).permit(:name, :year, :term, :about))

    if @course.save
      redirect_to @course, notice: "성공적으로 저장되었습니다."
    else
      render :new
    end

  end

  def edit

    @course = Course.find(params[:id])

  end

  def delete

    @course = Course.find(params[:id])
    @course.destroy

    redirect_to courses_path, notice: "성공적으로 삭제되었습니다."

  end

  def update

    @course = Course.find(params[:id])

    if @course.update_attributes(params[:course])
      redirect_to @course, notice: "성공적으로 반영되었습니다."
    else
      render edit
    end

  end

end
