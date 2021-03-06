class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook]

  has_many :friendships, dependent: :destroy
  has_many :friendships_inverse,
           class_name: "Friendship",
           foreign_key: :friend_id,
           dependent: :destroy
  has_many :relations, through: :friendships, source: :friend
  has_many :friends,
           -> { where(friendships: { status: 'accepted' }) },
           through: :friendships,
           source: :friend
  has_many :pending_friends,
           -> { where(friendships: { status: 'pending' }) },
           through: :friendships,
           source: :friend
  has_many :requested_friends,
           -> { where(friendships: { status: 'requested' }) },
           through: :friendships,
           source: :friend
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true

  # insensitive query
  scope :search, ->(target) { where("lower(name) like ? or uid = ? ",
                                    "%#{target.downcase}%", "#{target.to_i}") }
  scope :recent_reg, -> { order("created_at desc") }

  before_create :set_provider

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      # "first_or_create" method tries to load the first record.
      # If it fails, then "create" is called.
      # This method automatically sets "provider" and "uid"
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)##
      user.image = auth.info.image
      user.image_large = user.facebook.get_picture("me", height: 220, width: 220)
      user.save!
    end
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end

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

  private
  def set_provider
    self.provider ||= "dawnbank"
  end
end
