class NoticesController < ApplicationController
  def index
  end

  def show
  end

  def new
    @course = Course.find(params[:course_id])
    @notice = @course.notices.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def delete
  end
end
