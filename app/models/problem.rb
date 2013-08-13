class Problem < ActiveRecord::Base
  belongs_to :subject, foreign_key: "subject_id"
  has_many :assignments
  has_many :criterions, dependent: :destroy
  has_many :file_infos, as: :category, dependent: :destroy

  accepts_nested_attributes_for :criterions
  accepts_nested_attributes_for :file_infos
end
