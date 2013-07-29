# -*- coding: utf-8 -*-
class NoticesController < ApplicationController
  def index
    @course = Course.find(params[:course_id])
    @notices = @course.notices.all
  end

  def show
    @course = Course.find(params[:course_id])
    @notice = @course.notices.find(params[:id])
  end

  def new
    @course = Course.find(params[:course_id])
    @notice = @course.notices.new
  end

  def create
    @course = Course.find(params[:course_id])
    @notice = @course.notices.build(params[:notice])

    if @notice.save
      redirect_to course_notices_path, notice: "공지사항이 성공적으로 등록되었습니다."

    else
      redirect_to new_course_notice_path(@course), notice: "공지사항 등록에 실패하였습니다."
    end

  end

  def edit
    @course = Course.find(params[:course_id])
    @notice = @course.notices.find(params[:id])
  end

  def update
    @course = Course.find(params[:course_id])
    @notice = @course.notices.update_attributes(params[:notice])

    if @notice.save
      redirect_to course_notices_path, notice: "공지사항이 성공적으로 등록되었습니다."

    else
      redirect_to new_course_notice_path(@course), notice: "공지사항 등록에 실패하였습니다."
    end
  end

  def delete
    @course = Course.find(params[:course_id])
    @notice = @course.notices.find(params[:id])
  end
end
