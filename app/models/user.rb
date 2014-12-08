class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :name, presence: true

  has_many :friendships
  has_many :relations, through: :friendships, source: :friend
  has_many :friends, -> { where(friendships: { status: 'accepted' }) }, through: :friendships, source: :friend
  has_many :pending_friends, -> { where(friendships: { status: 'pending' }) }, through: :friendships, source: :friend
  has_many :requested_friends, -> { where(friendships: { status: 'requested' }) }, through: :friendships, source: :friend

  def has_relation_of?(@other)
    self.relations.include?(@other)
  end
end
