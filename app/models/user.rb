class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :send_welcome_email

  has_many :friend_requests
  has_many :pending_friend_requests, class_name: "FriendRequest", foreign_key: "friend_id"
  has_many :relationships, class_name: "FriendRequest", foreign_key: "friend_id"
  has_many :friends, through: :relationships, source: :user
  has_many :posts
  has_many :likes

  def post_feed
    friend_ids = self.friends.pluck(:id)
    friend_ids.push(self.id)
    Post.where(user_id: friend_ids).reverse
  end

  private

    def send_welcome_email
      UserMailer.welcome_email(self).deliver_now
    end
end
