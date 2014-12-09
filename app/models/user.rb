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

  def has_relation_of?(other)
    self.relations.include?(other)
  end

  def has_sent_request_to?(friend)
    self.pending_friends.include?(friend)
  end

  def has_got_request_from?(friend)
    self.requested_friends.include?(friend)
  end

  def is_friend_of?(friend)
    self.friends.include?(friend)
  end

  def sends_request_to(friend)
    transaction do
      Friendship.create!(user: self, friend: friend, status: 'pending')
      Friendship.create!(user: friend, friend: self, status: 'requested')
    end
  end

  def cancels_request_from(friend)
    transaction do
      @friendship = self.friendships.find_by_friend_id(friend.id)
      @friendship.destroy
      @friendship_inverse = friend.friendships.find_by_friend_id(self.id)
      @friendship_inverse.destroy
    end
  end

  def accepts_friend(friend)
    transaction do
      @friendship = self.friendships.find_by_friend_id(friend.id)
      @friendship.update!(status: 'accepted', accepted_at: Time.now)
      @friendship_inverse = friend.friendships.find_by_friend_id(self.id)
      @friendship_inverse.update!(status: 'accepted', accepted_at: Time.now)
    end
  end

  def removes_friend(friend)
    transaction do
      @friendship = self.friendships.find_by_friend_id(friend.id)
      @friendship.destroy
      @friendship_inverse = friend.friendships.find_by_friend_id(self.id)
      @friendship_inverse.destroy
    end
  end
end
