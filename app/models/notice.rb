# -*- coding: utf-8 -*-
class Notice < ActiveRecord::Base
  belongs_to :professor
  belongs_to :course

  validates :name, presence: {message: "공지사항의 제목을 입력하여 주십시오."}
  validates :content, presence: {message: "공지사항의 내용을 입력하여 주십시오."}
end
