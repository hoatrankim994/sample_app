class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.leng_content_max}
  validate  :picture_size
  scope :feed, -> (user_id) do
    following_ids = Relationship.follower_user_by_user_id(user_id)
    all_user_ids = following_ids + [user_id]
    where user_id: all_user_ids
  end

  private

  def picture_size
    return if picture.size <= Settings.pic_size.megabytes
    errors.add(:picture, t("pic_less_5"))
  end
end
