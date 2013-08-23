class Comment < ActiveRecord::Base
  belongs_to :professor
  belongs_to :assignment
end
