class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :send_welcome_email

  has_many :friend_requests
  has_many :pending_friend_requests, class_name: "FriendRequest", foreign_key: "friend_id"
  has_many :posts

  private

    def send_welcome_email
      UserMailer.welcome_email(self).deliver_now
    end
end
