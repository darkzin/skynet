# -*- coding: utf-8 -*-
class StudentsController < ApplicationController

  def index
    @students = Student.all
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])
    @student.update(params)

    if @student.save!
      flash[:notice] = "성공적으로 반영되었습니다."
    else
      flash[:notice] = "업데이트에 실패하였습니다."
    end

    redirect_to student_path(@student)
  end

  def show
    @student = Student.find(params[:id])
    @courses = @student.courses.all
  end

end
