# -*- coding: utf-8 -*-
class ProfessorsController < ApplicationController

  def index
    @professors = Professor.all
  end

  def edit
    id = params.permit(:id)[:id]

    if are_you_root? || current_professor.id == id
      @professor = Professor.find(params.permit(:id)[:id])
    else
      redirect_to root_path, warning: "본인만이 본인정보수정에 접근할 수 있습니다."
    end

  end

  def update
    @professor = Professor.find(params.permit(:id)[:id])
    @professor.update(params.require(:professor).permit(:name, :phone_number, :about))

    if @professor.save!
      flash[:success] = "개인정보 내용이 성공적으로 반영되었습니다."
    else
      flash[:error] = "개인정보 업데이트에 실패하였습니다. 관리자에게 문의해보세요."
    end

    redirect_to professor_path(@professor)
  end

  def show
    @professor = Professor.find(params[:id])
    @courses = @professor.courses.all
  end

end
