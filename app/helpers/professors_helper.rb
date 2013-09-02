module ProfessorsHelper
  def current_course_id
    if params.permit(:course_id).present?
      params.permit(:course_id)[:course_id]
    elsif params.permit(:subject_id).present?
      Subject.find(params.permit(:subject_id)[:subject_id]).course.id
    elsif params.permit(:problem_id).present?
      Problem.find(params.permit(:problem_id)[:problem_id]).subject.course.id
    else
      params.permit(:id)[:id]
    end
  end

  def can_i_manage_this_course?
    professor_signed_in? && current_professor.courses.find_by_id(current_course_id)
  end

  def am_i_enroll_this_course?
    student_signed_in? && current_student.courses.find_by_id(current_course_id)
  end
end
