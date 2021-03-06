class Post < ActiveRecord::Base
  belongs_to :author, class_name: "User", foreign_key: :user_id

  validates :title, presence: true
  validates :content, presence: true

  has_many :comments, dependent: :destroy

  scope :recent, -> { order("created_at DESC") }
  scope :search, ->(target) { where("title like ? or content like ?",
                                    "%#{target}%", "%#{target}%") }
end
