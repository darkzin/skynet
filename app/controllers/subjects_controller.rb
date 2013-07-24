# -*- coding: utf-8 -*-
class SubjectsController < ApplicationController
  def index
    @subjects = Subject.all
  end

  def show
    @subject = Subject.find(params[:id])
    @files = @subject.file_infos.all
    @problems = @subject.problems.all
  end

  def new
  end

  def create
    @subject = Subject.new(params[:subject])

    if @subject.save
      redirect_to @subject, notice: "성공적으로 저장되었습니다."
    else
      render :new
    end
  end

  def edit
    @subject = Subject.find(params[:id])
    @files = @subject.file_infos.all
    @problems = @subject.problems.all
  end

  def update
    @subject = Subject.find(params[:id])

    if @subject.update_attributes(params[:subject])
      redirect_to @subject, notice: "성공적으로 반영되었습니다."
    else
      render edit
    end
  end

end
