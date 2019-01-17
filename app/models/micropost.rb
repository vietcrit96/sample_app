class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.content_length_max}
  validate :picture_size
  scope :order_desc, ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader

  private

  def picture_size
    return unless picture.size > Settings.picture_max_size.megabytes
    errors.add :picture, I18n.t("less_than_5")
  end
end
