# -*- coding: utf-8 -*-
class ProblemsController < ApplicationController
  before_action :permit_professor!

  def index
  end

  def show
  end

  def new
    @subject = Subject.find(params.permit(:subject_id)[:subject_id])
    @course = @subject.course
    @problem = @subject.problems.new
    @problem.criterions.build
    @problem.file_infos.build
  end

  def edit
  end

  def update
  end

  def create
    @subject = Subject.find(params.permit(:subject_id)[:subject_id])
    @problem = @subject.problems.new(params.require(:problem).permit(:name, :content, :input_data, :model_paper, :script, :compile_command, criterions_attributes: [:name, :score]))

    file_infos = params.require(:problem).permit(:file_infos_attributes => [])[:file_infos_attributes]
    file_infos.each do |file|
      @problem.file_infos.new(name: file.original_filename, extension: File.extname(file.original_filename), file: file)
    end

    if @problem.save
      redirect_to new_subject_problem_path(params[:subject_id]), flash: { success: "문제를 성공적으로 저장했습니다. 다음 문제를 입력해주세요."}
    else
      redirect_to new_subject_problem_path(params[:subject_id]), flash: { error: "문제 저장에 실패하였습니다. " + @problem.errors.full_messages.join(" ")}
    end
  end

  def destroy
    @subject = Subject.find(params.permit(:subject_id)[:subject_id])
    @course = @subject.course
    @problem = @subject.problems.find(params.permit(:id)[:id])
    @problem.destroy

    redirect_to [@course, @subject]
  end

  def csv
    @problem = Problem.find(params[:id])
    @subquery = Assignment.select('student_id, MAX(created_at) as max_created_at').group(:student_id).where(problem_id: @problem.id).to_sql
    @assignments = @problem.assignments.joins("INNER JOIN (#{@subquery}) max_data ON (assignments.student_id = max_data.student_id AND assignments.created_at = max_data.max_created_at)").order(student_id: :asc).to_a
    result_column_names = ["학번", "이름", "점수", "만점", "상태", "제출파일", "시간", "메모리"]
    problem_id_list = []

    criterions = @problem.criterions.all.to_a
    if criterions.empty?
      problem_score = 10
    else
      problem_score = 0
      criterions.each do |criterion|
        problem_score += (criterion.score.nil? ? 0 : criterion.score)
      end
    end # if end.

    c = CSV.generate do |csv|
      csv << result_column_names
      result = []
      @assignments.each do |assignment|
        student = assignment.student
        files = assignment.file_infos.map do |file_info|
            file_info.file.path
            end.join(" / ")

        result = [student.student_number, student.name, assignment.score, problem_score, assignment.state, files, assignment.lead_time, assignment.memory_usage]
        csv << result
      end # @assignment loop end.

    end # csv loop end.

    send_data c.to_s, filename: "problem_result.csv"
  end # csv action end.
end
