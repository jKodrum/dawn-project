class Comment < ActiveRecord::Base
  belongs_to :commenter, class_name: "User", foreign_key: :user_id
  belongs_to :post

  validates :content, presence: true
end
