# frozen_string_literal: true

require 'bundler/setup'
Bundler.require
require 'sinatra'
require 'sinatra/reloader' if development?
require './models/models.rb'
require 'pry'

enable :sessions

helpers do
  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find(session[:user_id])
  end
end


# *** get ***

# ホーム画面
get '/' do
  if logged_in?
    @user = current_user
    p session[:user_id]
    erb :home
  else
    erb :lp
  end
end

# 新規登録画面
get '/signup' do
  if logged_in?
    redirect '/'
  else
    erb :signup
  end
end

# ログイン画面
get '/signin' do
  if logged_in?
    redirect '/'
  else
    erb :signin
  end
end

# ログイン成功
get '/signup_success' do

  erb :signup_success
end

# ログアウト
get '/logout' do
  session[:user_id] = nil
  redirect '/'
end

# 権限付与画面
get '/give_permisson/:id' do

end

# グループ作成画面
get '/create_group' do

end

# グループ画面
get '/group/:id' do

end

# 投稿画面
get '/create_contribution' do

end

# 投稿編集画面
get '/edit_contribution/:id' do

end

# 投稿削除画面
get '/confirm_destroy_contribution/:id' do

end

# *** post ***

# ユーザーの作成
post '/create_user' do
  if params[:password] == params[:confirm]
    user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password],
      role: 'member'
    )
    if user.save
      session[:user_id] = user.id
    else
      redirect '/signup'
    end
  else
    redirect '/signup'
  end
  redirect '/signup_success'
end

# ログイン
post '/signin' do
  user = User.find_by(email: params[:email])
  if user
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/'
    else
      redirect '/signin'
    end
  else
    redirect '/signin'
  end
end

# メンター権限の付与
post '/give_permisson/:id' do

end

# グループの作成
post '/create_group' do

end

# ユーザーをグループへ招待
post '/invite_user/:id' do

end


# ステータスの変更
post '/change_status/:id' do

end


# 投稿の編集
post '/edit_contribution/:id' do

end

# 投稿の削除
post '/destroy_contribution/:id' do

end

# 投稿の新規作成
post '/create_contribution' do

end