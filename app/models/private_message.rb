class PrivateMessage < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User', foreign_key: 'user_from_id'
  belongs_to :user_to, class_name: 'User', foreign_key: 'user_to_id'

  has_many :child, class_name: 'PrivateMessage', foreign_key: 'to_message_id'
  belongs_to :parent, class_name: 'PrivateMessage', foreign_key: 'to_message_id'

  mount_uploader :file, PmFileUploader
end
