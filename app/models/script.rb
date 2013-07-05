class Script < ActiveRecord::Base
  belongs_to :problem
  has_one :file_info, dependent: :destroy
end
