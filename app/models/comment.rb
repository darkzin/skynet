# -*- coding: utf-8 -*-
class Comment < ActiveRecord::Base
  belongs_to :professor
  belongs_to :assignment

  validates :content, presence: {message: "댓글의 제목을 입력하여 주십시오."}
end
