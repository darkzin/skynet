# -*- coding: utf-8 -*-
class Problem < ActiveRecord::Base
  before_save :set_default

  belongs_to :subject, foreign_key: "subject_id"
  has_many :assignments
  has_many :criterions, dependent: :destroy
  has_many :file_infos, as: :category, dependent: :destroy
  mount_uploader :script, FileUploader

  validates :name, presence: {message: "문제의 제목을 입력하여 주십시오."}

  accepts_nested_attributes_for :criterions
  accepts_nested_attributes_for :file_infos

  protected
  def set_default
    self.compile_command |= "lua"
  end

end
