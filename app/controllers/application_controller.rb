class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def authenticate_user!
    unless params[:controller] != "professors" && (student_signed_in? || professor_signed_in?)
      authenticate_student!
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    @courses = current_user.courses.all

    if @courses.count == 0
      courses_path
    else
      course_path(@courses.first)
    end
  end

  def print_params
    p params
  end

  def current_user
    if student_signed_in?
      current_student
    elsif professor_signed_in?
      current_professor
    else
      nil
    end
  end
end
