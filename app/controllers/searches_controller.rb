class SearchesController < ApplicationController
  before_action :authenticate_user!
  
  def search
    @range = params[:range] #params[:range]で選択された範囲（range）を@rangeに代入
    if @range == "User" #if文で検索モデルを分岐
      @users = User.looks(params[:search], params[:word]) #User.looksで検索方法（:search）と検索ワード（:word）のデータを検索し、それをインスタンス変数に代入
    else                                                  
      @books = Book.looks(params[:search], params[:word])
    end
  end
end
