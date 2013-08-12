class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!, :set_user_info
  #before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def authenticate_user!
    unless (student_signed_in? || professor_signed_in?) && not(request.path.include? "professors")
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

  def devise_parameter_sanitizer
    if resource_class == Student
      Student::ParameterSanitizer.new(Student, :student, params)
    elsif resource_class = Professor
      Professor::ParameterSanitizer.new(Professor, :professor, params)
    end
  end

  def set_user_info
    @current_user_courses = current_user.courses.all

    if current_user.last_selected_course_id
      @current_user_course = Course.find(current_user.last_selected_course_id)
    else
      @current_user_course = @current_user_courses.first
    end

    @current_user_courses.delete @current_user_course
  end

end
