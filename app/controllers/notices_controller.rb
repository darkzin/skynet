# -*- coding: utf-8 -*-
class NoticesController < ApplicationController
  before_action :permit_professor!, except: [:index, :show]

  def index
    @course = Course.find(params.permit(:course_id)[:course_id])
    @notices = @course.notices.all
  end

  def show
    @course = Course.find(params.permit(:course_id)[:course_id])
    @notice = @course.notices.find(params.permit(:id)[:id])
  end

  def new
    @course = Course.find(params.permit(:course_id)[:course_id])
    @notice = @course.notices.new
  end

  def create
    @course = Course.find(params.permit(:course_id)[:course_id])
    notice_params = params.require(:notice).permit(:name, :content)
    notice_params[:professor_id] = current_professor.id
    @notice = @course.notices.build(notice_params)

    if @notice.save
      redirect_to course_notices_path, notice: "공지사항이 성공적으로 등록되었습니다."

    else
      redirect_to new_course_notice_path(@course), notice: "공지사항 등록에 실패하였습니다."
    end

  end

  def edit
    @course = Course.find(params.permit(:course_id)[:course_id])
    @notice = @course.notices.find(params.permit(:id)[:id])
  end

  def update
    @course = Course.find(params.permit(:course_id)[:course_id])
    @notice = @course.notices.find(params.permit(:id)[:id])
    @notice.update_attributes(params.require(:notice).permit(:name, :content))

    if @notice.save
      redirect_to course_notices_path, notice: "공지사항이 성공적으로 등록되었습니다."

    else
      redirect_to new_course_notice_path(@course), notice: "공지사항 등록에 실패하였습니다."
    end
  end

  def destroy
    @course = Course.find(params.permit(:course_id)[:course_id])
    @notice = @course.notices.find(params.permit(:id)[:id])

    if @notice.destroy
      redirect_to course_notices_path, flash: { success: "공지사항이 성공적으로 삭제되었습니다." }
    else
      redirect_to course_notices_path, flash: { alert: "공지사항 삭제에 실패했습니다. 관리자에게 문의하세요." }
    end
  end
end
