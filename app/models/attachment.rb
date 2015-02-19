class Attachment < ActiveRecord::Base
  mount_uploader :image, AttachUploader
  belongs_to :code
  validates_presence_of :image
end
