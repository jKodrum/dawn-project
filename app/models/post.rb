class Post < ActiveRecord::Base
  belongs_to :author, class_name: "User", foreign_key: :user_id

  validates :title, presence: true
  validates :content, presence: true

  scope :recent, -> { order("updated_at DESC") }
end
