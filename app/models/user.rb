class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites,dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  #相互フォロー同士のDM
  has_many :user_rooms
  has_many :chats
  has_many :rooms, through: :user_rooms
  
  #フォロー、フォロワー機能
  has_many :relationships, class_name: 'Relationship', foreign_key: "follower_id", dependent: :destroy #フォローした
  has_many :followings, through: :relationships, source: :followed #@user.followingsでフォローしている人の一覧を表示できる
  has_many :reverce_of_relationships, class_name: 'Relationship', foreign_key: "followed_id", dependent: :destroy #フォローされた
  has_many :followers, through: :reverce_of_relationships,source: :follower #@user.followersでフォローされている人の一覧を表示
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
  
  #検索方法分岐
  def self.looks(search,word)
    if search == "perfect_match" #送られてきたsearchが完全一致だった場合
      @user = User.where("name LIKE?","#{word}") #whereメソッドでDBから該当データ(nameカラムの#{word}(検索したい文字列))を全て取得し、変数に代入
    elsif search == "forward_match" #送られてきたsearchが前方一致だった場合
      @user = User.where("name LIKE?","#{word}%") #LIKE?は部分的に検索したワードが含まれているかを確認するメソッド
    elsif search == "backward_match" #送られてきたsearchが後方一致だった場合
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match" #送られてきたsearchが部分一致だった場合
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end
end
