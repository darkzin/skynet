class FileInfo < ActiveRecord::Base
  belongs_to :category, polymorphic: true
  include Rails.application.routes.url_helpers
  mount_uploader :file, FileUploader


  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    {
      "name" => read_attribute(:file),
      "size" => file.size,
      "url" => file.url,
      "thumbnail_url" => file.thumb.url,
      "delete_url" => file_info_path(:id => id),
      "delete_type" => "DELETE"
    }
  end
end
