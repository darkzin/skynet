# -*- coding: utf-8 -*-
class CoursesController < ApplicationController
  before_action :permit_professor!, only: [:destroy, :edit, :csv]

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params.permit(:id)[:id])

    redirect_to courses_path, alert: "등록된 수업이 없습니다. 관리자에게 문의하세요." if @course.nil?

    current_user.last_selected_course_id = params.permit(:id)[:id]
    current_user.save

    if not(current_user.last_sign_in_at.nil?) && current_user.last_sign_in_at > 7.days.ago
      latest_date = 1.week.ago
    else
      latest_date = current_user.last_sign_in_at
    end

    @latest_notice = @course.notices.where("created_at >= ?", latest_date).order("created_at DESC")
    @outdate_notice = @course.notices.where("created_at < ?", latest_date).order("created_at DESC")

    @outdate_subjects = @course.subjects.all.to_a
    @current_subjects = []

    @outdate_subjects.delete_if do |subject|
      if subject.deadlines.where("start <= ?", DateTime.now).where("end >= ?", DateTime.now).any?
        @current_subjects << subject
      elsif subject.deadlines.where("start > ?", DateTime.now).where("end > ?", DateTime.now).any?
        true
      else
        false
      end
    end
    @all_subjects = @outdate_subjects + @current_subjects
  end

  def new
    @course = current_professor.courses.new
  end

  def create
    @course = current_professor.courses.new(params.require(:course).permit(:name, :content, :year, :term))

    if @course.save
      current_user.last_selected_course_id = @course.id
      redirect_to @course, flash: { success: "새로운 과목이 성공적으로 개설되었습니다. 이제 과제를 만들어주세요." }
    else
      render :new, flash: { error: "과제 개설에 실패했습니다. " + @course.errors.full_messages.join(" ") }
    end

  end

  def edit
    @course = current_professor.courses.find(params.permit(:id)[:id])
  end

  def delete
    @course = current_professor.courses.find(params.permit(:id)[:id])
    @course.destroy

    redirect_to courses_path, notice: "과목이 성공적으로 폐지되었습니다."
  end

  def update
    @course = current_professor.courses.find(params.permit(:id)[:id])

    if @course.update_attributes(params.require(:course).permit(:name, :content, :year, :term))
      redirect_to @course, notice: "과목의 내용이 성공적으로 수정되었습니다."
    else
      render edit, flash: { error: "과목 내용 수정에 실패하였습니다. " + @course.errors.full_messages.join(" ") }
    end
  end

  def csv
    @course = Course.find(params[:id])
    @subject = @course.subjects.order(id: :asc).all.to_a
    result_column_names = ["학번", "이름"]
    problem_id_list = []
    @subject.each_with_index do |subject, s_index|
      problems = subject.problems.order(id: :asc).all.to_a
      problems.each_with_index do |problem, p_index|
        result_column_names << "#{s_index + 1}_#{p_index + 1}점수"
        problem_id_list << problem.id
      end
    end
    @students = @course.students.all.to_a
    c = CSV.generate do |csv|
      csv << result_column_names
      @students.each do |student|
        result = [student.student_number, student.name]
        problem_id_list.each do |problem_id|
          problem = Problem.find(problem_id)
          best_score_assignment = problem.assignments.where(student_id: student.id).order(score: :desc).first
          result << (best_score_assignment.nil? ? '0' : best_score_assignment.score.to_s)
        end # problem_id_list loop end.
        csv << result
      end # @students loop end.
      @problems = Problem.find(problem_id_list)
      result = ["만점", "만점"]
      @problems.each do |problem|
        criterions = problem.criterions.all.to_a
        if criterions.empty?
          score = 10
        else
          score = 0
          criterions.each do |criterion|
            score += (criterion.score.nil? ? 0 : criterion.score)
          end
        end # if end.
        result << score.to_s
      end
      csv << result
    end # csv loop end.

    send_data c.to_s, filename: "course_result.csv"
  end # csv action end.
end
