class StudentsController < ApplicationController
  before_filter :authenticate_user!, except: [:new, :create]

  def index
    #학생이 자신의 수업 리스트를 확인
    @courses_list = current_user.courses
    @courses = Course.find(@courses_list).desc(:year)
  end

  def create
  end

  def new
  end

  def edit
  end

  def delete
  end

  def update
  end

  def show
  end
end
