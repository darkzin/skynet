module ProfessorsHelper
  def can_i_manage_this_course?
    professor_signed_in? && current_professor.courses.find_by_id(current_course_id)
  end

  def am_i_enroll_this_course?
    student_signed_in? && current_student.courses.find_by_id(current_course_id)
  end
end
