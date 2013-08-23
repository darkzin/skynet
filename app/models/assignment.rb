class Assignment < ActiveRecord::Base
  belongs_to :student
  belongs_to :problem
  has_many :file_infos, as: :category, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :file_infos

end
