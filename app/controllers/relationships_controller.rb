class RelationshipsController < ApplicationController
  
  def create #フォローする時
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end
  
  def destroy #フォロー外す時
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end
  
  def followings #フォロー一覧
    user = User.find(params[:user_id])
    @users = user.followings
  end
  
  def followers #フォロワー一覧
    user = User.find(params[:user_id])
    @users = user.followers
  end
end