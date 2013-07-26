class Assignment < ActiveRecord::Base
  belongs_to :student
  belongs_to :problem
  has_many :file_infos, as: :category, dependent: :destroy
end
