# -*- coding: utf-8 -*-
class ProfessorsController < ApplicationController

  def index
    @professors = Professor.all
  end

  def edit
    @professor = Professor.find(params[:id])
  end

  def update
    @professor = Professor.find(params[:id])
    @professor.update(params)

    if @professor.save!
      flash[:notice] = "성공적으로 반영되었습니다."
    else
      flash[:notice] = "업데이트에 실패하였습니다."
    end

    redirect_to professor_path(@professor)
  end

  def show
    @professor = Professor.find(params[:id])
    @courses = @professor.courses.all
  end

end
