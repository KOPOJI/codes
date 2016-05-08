class Code < ActiveRecord::Base
  validates_presence_of :code
  validates_length_of :code, minimum: 10, maximum: 60000
  #validates :image, file_size: { maximum: 5.megabytes.to_i}

  before_create :assign_unique_token
  after_save :set_title

  has_many :attachments
  belongs_to :user
  accepts_nested_attributes_for :attachments

  after_initialize :init

  def assign_unique_token
    self.code_url = Digest::SHA1.hexdigest(Time.now.to_s)
  end
  def set_title
    self.update!(title: "Unnamed ##{self.id}") if self.title.blank?
  end

  def init
    self.title = "#{I18n.t 'Code'} ##{self.id}" if self.title.blank? or self.title == "Unnamed ##{self.id}"
  end

end
