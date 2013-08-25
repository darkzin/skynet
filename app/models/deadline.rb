# -*- coding: utf-8 -*-
class Deadline < ActiveRecord::Base
  belongs_to :subject

  validates :start, presence: {message: "과제시한의 시작을 입력하여 주십시오."}
  validates :end, presence: {message: "과제시한의 끝을 입력하여 주십시오."}
  validates :penalty, presence: {message: "해당 시한 내에 재출 시 부여될 페널티를 입력하여 주십시오."}
end
