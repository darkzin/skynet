class Subject < ActiveRecord::Base
  belongs_to :course
  has_many :file_infos, dependent: :destroy
  has_many :problems, dependent: :destroy
  has_many :deadlines, dependent: :destroy
end
