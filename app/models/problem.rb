class Problem < ActiveRecord::Base
  belongs_to :subject
  has_many :assignment
  has_many :criterions, dependent: :destroy
  has_many :file_infos, as: :category, dependent: :destroy

  accepts_nested_attributes_for :criterions
end
