class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_student!, :print_params

  def authenticate_user!
    authenticate_student! || authenticate_professor!
  end

  def after_sign_in_path_for(resource_or_scope)
    @courses = current_student.courses.all

    if @courses.count == 0
      courses_path
    else
      course_path(@courses.first)
    end
  end

  def print_params
    p params
  end

end
