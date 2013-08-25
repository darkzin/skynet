class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  #before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def authenticate_user!
    unless (student_signed_in? || professor_signed_in?) && not(request.path.include? "professors")
      authenticate_student!
    else
      set_user_info
    end
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

  def set_user_info
    @current_user_courses = current_user.courses.all || []

    if current_user.last_selected_course_id
      @current_user_course = Course.find(current_user.last_selected_course_id)
    else
      @current_user_course = @current_user_courses.first
    end

    @current_user_courses.delete @current_user_course
  end

  def after_sign_in_path_for(resource_or_scope)
    @current_user_courses ||= []

    if @current_user_courses.empty?
      courses_path
    else
      course_path(@current_user_course)
    end
  end

  def devise_parameter_sanitizer
    if resource_class == Student
      Student::ParameterSanitizer.new(Student, :student, params)
    elsif resource_class = Professor
      Professor::ParameterSanitizer.new(Professor, :professor, params)
    end
  end

  def print_params
    p params
  end

  def are_you_root?
    current_professor.email == "root@hanyang.ac.kr"
  end

  def am_i_here?(association, id)
    @association = current_user.send(association).find(id)
    not @association.nil?
  end

end
