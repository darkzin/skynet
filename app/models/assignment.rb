class Assignment < ActiveRecord::Base
  belongs_to :student
  belongs_to :problem
  has_many :file_infos, as: :category, dependent: :destroy
  has_many :comments, dependent: :destroy

  # validates :state, presence: true
  # validates :lead_time, presence: true
  # validates :memory_usage, presence: true
  # validates :result, presence: true

  accepts_nested_attributes_for :file_infos
end
