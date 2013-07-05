class Problem < ActiveRecord::Base
  belongs_to :subject
  has_one :script, dependent: :destroy
  has_many :assignment
  has_many :criteria, dependent: :destroy
  has_many :file_infos, as: :category, dependent: :destroy
end
