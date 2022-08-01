class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites,dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :follower
  
  has_many :reverce_of_relationships, class_name: 'relationships', foreign_key: "followerd_id", dependent: :destroy
  has_many :followers, through: :reverce_of_relationships,source: :following
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}
  
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  #relationships_controllerで使うメソッド↓
  
  def follow(user_id) #フォローした時の処理
    relationships.create(followed_id: user_id)
  end
  
  def unfollow(user_id) #フォローを外すときの処置
    relationships.find_by(followed_id: user_id).destroy
  end
  
  def following?(user) #フォローしているかの判定
    followings.include?(user)
  end
end
