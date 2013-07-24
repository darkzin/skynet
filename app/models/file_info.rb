class FileInfo < ActiveRecord::Base
  belongs_to :category, polymorphic: true
  mount_uploader :file, FileUploader
end
