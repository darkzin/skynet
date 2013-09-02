# -*- coding: utf-8 -*-
class Deadline < ActiveRecord::Base
  scope :by_end, order("end ASC")
  default_scope by_end

  belongs_to :subject

  validates :start, presence: {message: "과제시한의 시작을 입력하여 주십시오."}
  validates :end, presence: {message: "과제시한의 끝을 입력하여 주십시오."}
  validates :penalty, presence: {message: "해당 시한 내에 재출 시 부여될 페널티를 입력하여 주십시오."}

  validate :start_must_earier_than_end, on: :create

  def start_must_earier_than_end
    errors.add(:end, "종료일시는 시작일시보다 무조건 커야합니다.") if self.start >= self.end
  end
end
