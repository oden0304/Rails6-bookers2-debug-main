class ChatsController < ApplicationController
  before_action :reject_non_related, only: [:show] #相互フォローかどうかを確認する
  def show
    @user = User.find(params[:id]) #チャットする相手を探してくる
    rooms = current_user.user_rooms.pluck(:room_id) #ログイン中ユーザーの部屋情報を全て取得
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms) #その中にチャットする相手とルームがあるか確認

    unless user_rooms.nil? #ユーザールームがあった場合（unless）
      @room = user_rooms.room #@roomにユーザー（自分と相手）と紐づいているroomを代入
    else #ユーザールームがなかった場合
      @room = Room.new #新しくroomを作る
      @room.save #roomを保存
      UserRoom.create(user_id: current_user.id, room_id: @room.id) #自分の中間テーブルを作る
      UserRoom.create(user_id: @user.id, room_id: @room.id) #相手の中間テーブルを作る
    end
    @chats = @room.chats #チャットの一覧用変数
    @chat = Chat.new(room_id: @room.id) #チャット投稿用変数
  end
  def create
    @chat = current_user.chats.new(chat_params)
    
  end

  private
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def reject_non_related
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user) #自分がフォローしているかつ相手が自分をフォローしてない時
      redirect_to books_path
    end
  end
end
