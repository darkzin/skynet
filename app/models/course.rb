# -*- coding: utf-8 -*-
class Course < ActiveRecord::Base
  belongs_to :professor
  has_many :students, through: :enrolls
  has_many :notices, dependent: :destroy
  has_many :subjects
  has_one :option

  validates :name, presence: {message: "과목명을 입력하여 주십시오."}
  validates :content, presence: {message: "과목 설명을 입력하여 주십시오."}
  validates :year, presence: {message: "과목이 개설된 년도를 입력하여 주십시오."}
  validates :term, presence: {message: "과목이 개설된 학기를 숫자로 입력하여 주십시오."}
end
