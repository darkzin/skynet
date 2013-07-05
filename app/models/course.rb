class Course < ActiveRecord::Base
  belongs_to :professor
  has_many :students, through: :enrolls
  has_many :notices, dependent: :destroy
  has_many :subjects
end
