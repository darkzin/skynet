# -*- coding: utf-8 -*-
class CommentsController < ApplicationController
  before_action :permit_user!, only: [:create, :destroy, :update]

  def index
  end

  def new
  end

  def show
  end

  def create
    @comment = current_professor.comments.new(params.require(:comment).permit(:content))
    @assignment = Assignment.find(params.permit(:assignment_id)[:assignment_id])
    @problem = @assignment.problem
    if @comment.save
      redirect_to [ @problem, @assignment ], flash: { success: "코멘트가 성공적으로 작성되었습니다." }
    else
      redirect_to [ @problem, @assignment ], flash: { error: "코멘트 작성에 실패하었습니다. 다시 작성해 주세요." }
    end
  end

  def destroy
    @assignment = Assignment.find(params.permit(:assignment_id)[:assignment_id])
    @comment = @assignment.comments.find(params.permit(:id)[:id])

    if @comment.destroy
      redirect_to [ @problem, @assignment ], flash: { success: "코멘트가 성공적으로 삭제되었습니다." }
    else
      redirect_to [ @problem, @assignment ], flash: { error: "코멘트 삭제에 실패하었습니다. 다시 시도해 주세요." }
    end
  end

  def update
  end
end
