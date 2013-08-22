# -*- coding: utf-8 -*-
class CoursesController < ApplicationController

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])


    redirect_to courses_path, notice: "등록된 수업이 없습니다. 관계자에게 문의하세요." if @course.nil?

    current_user.last_selected_course_id = params.permit(:id)[:id]
    current_user.save

    if not(current_user.last_sign_in_at.nil?) && current_user.last_sign_in_at > 7.days.ago
      latest_date = 7.days.ago
    else
      latest_date = current_user.last_sign_in_at
    end

    @latest_notice = @course.notices.where("created_at >= ?", latest_date).order("created_at DESC")
    @outdate_notice = @course.notices.where("created_at < ?", latest_date).order("created_at DESC")

    @current_subjects = @course.subjects.all
    @outdate_subjects = []

    @current_subjects.delete_if do |subject|
      if subject.deadlines.where("start <= ?", DateTime.now).where("end >= ?", DateTime.now).empty?
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

    @course = current_professor.courses.new(params.require(:course).permit!)

    if @course.save
      redirect_to @course, notice: "성공적으로 저장되었습니다."
    else
      render :new
    end

  end

  def edit

    @course = current_professor.courses.find(params[:id])

  end

  def delete

    @course = current_professor.courses.find(params[:id])
    @course.destroy

    redirect_to courses_path, notice: "성공적으로 삭제되었습니다."

  end

  def update

    @course = current_professor.courses.find(params[:id])

    if @course.update_attributes(params[:course])
      redirect_to @course, notice: "성공적으로 반영되었습니다."
    else
      render edit
    end

  end

end
