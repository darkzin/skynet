# -*- coding: utf-8 -*-
class Problem < ActiveRecord::Base
  belongs_to :subject, foreign_key: "subject_id"
  has_many :assignments
  has_many :criterions, dependent: :destroy
  has_many :file_infos, as: :category, dependent: :destroy

  validates :name, presence: true, message: "문제의 제목을 입력하여 주십시오."
  validates :compile_command, presence: true, message: "문제를 컴파일할 때 사용할 커맨드를 입력하여 주십시오."

  accepts_nested_attributes_for :criterions
  accepts_nested_attributes_for :file_infos
end
