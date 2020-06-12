# frozen_string_literal: true

require 'bundler/setup'
Bundler.require
require 'sinatra'
require 'sinatra/reloader' if development?
require "sinatra/activerecord"
require './models/models.rb'
require 'pry'
require 'carrierwave'
require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
  config.root = File.dirname(__FILE__) + "/public"
  config.storage = :file
end


enable :sessions

helpers do
  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find(session[:user_id])
  end

  def login_required
    redirect '/login' if session[:user_id].nil?
  end

  def logout_required
    p session[:user_id]
    redirect '/' if session[:user_id]
  end

  # def mentor?
  #   @user.role == 'mentor' if @user
  # end

  # def admin?
  #   @user.role == 'admin' if @user
  # end
end

before do
  @logged_in = logged_in?
  @user = current_user if @logged_in
  color = {
    "admin" => 'bg-info',
    "mentor" => 'bg-success',
    "member" => 'bg-dark'
  }
  @background_color = color[@user.role] if @user
end

# *** get ***

### ログインいらない

# 新規登録画面
get '/signup' do
  logout_required
  @page_title = "新規登録"
  erb :signup
end

# ログイン画面
get '/login' do
  logout_required
  @page_title = "ログイン"
  erb :login
end

# lp(命名微妙です)

get '/lp' do
  logout_required
  erb :lp
end

######################

### ログイン必要

# ホーム画面
get '/' do
  login_required
  @page_title = "home"
  @user = current_user
  @groups = @user.groups
  binding.pry
  erb :home
end

# ログアウト
get '/logout' do
  login_required
  session[:user_id] = nil
  p session[:user_id]
  redirect '/login'
end

# ログイン成功
get '/signup_success' do
  login_required
  @page_title = "signup success"
  erb :signup_success
end

# 権限付与画面
get '/give_permission' do
  login_required
  redirect '/' unless @user.role == 'admin'
  @all_mentor = User.where(role: 'mentor')
  erb :give_permission
end

# グループ作成画面
get '/create_group' do
  login_required
  redirect '/' unless @user.role == 'mentor' || @user.role == 'admin'
  erb :create_group
end

# グループ画面
get '/group/:id' do
  login_required
  @group = Group.find_by(id: params[:id])
  @group_users = @group.users
  @contributions = @group.contributions
  @page_title = @group.name
  @role = {
    'mentor': 'メンター',
    'member': 'メンバー'
  }
  @priority_color = {
    'high' => 'bg-danger',
    'medium' => 'bg-warning',
    'low' => 'bg-primary'
  }
  @status_color = {
    'new' => 'bg-info',
    'doing' => 'bg-primary',
    'done' => 'bg-success',
  }
  @priority_badge = {
    'high' => ['badge-danger', 'やばい'],
    'medium' => ['badge-warning', 'まあまあ'],
    'low' => ['badge-primary', 'できれば']
  }
  @status_badge = {
    'new' => ['badge-info', 'これから'],
    'doing' => ['badge-primary', '取り掛かり中'],
    'done' => ['badge-success', '終わり']
  }
  erb :group
end

# 投稿編集画面
get '/edit_contribution/:group_id/:contribution_id' do
  login_required
  @page_title = "投稿編集ページ"
  @contribution = Contribution.find_by(id: params[:contribution_id])
  @group_id = params[:group_id]
  erb :edit_contribution
end

# 投稿削除画面
get '/confirm_destroy_contribution/:group_id/:contribution_id' do
  login_required
  @contribution = Contribution.find_by(id: params[:contribution_id])
  @group_id = params[:group_id]
  erb :destroy_contribution
end
# *** post ***

# ユーザーの作成
post '/create_user' do
  if params[:password] == params[:confirm]
    user = User.new(
      name: params[:name],
      screen_name: params[:screen_name],
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
post '/login' do
  user = User.find_by(email: params[:email])
  if user
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/'
    else
      redirect '/login'
    end
  else
    redirect '/login'
  end
end

# メンター権限の付与
post '/give_permission/:user_id' do
  user = User.find_by(name: params[:user_id])
  if user
    user.role = 'mentor'
    user.save
  end
  p user
  redirect '/give_permission'
end

# グループの作成
post '/create_group' do
  group = Group.create(
    name: params[:name],
    description: params[:description]
  )
  UserGroup.create(
    group_id: group.id,
    user_id: current_user.id
  )

  redirect "group/#{group.id}"
end

# ユーザーをグループへ招待
post '/invite_user/:group_id/:user_id' do
  group_id = params[:group_id]
  user = User.find_by(name: params[:user_id])
  if !!user
    UserGroup.create!(
      user_id: user.id,
      group_id: group_id
    )
  end
end

post '/change_priority/:id' do
  contribution = Contribution.find_by(id: params[:id])
  contribution.priority = params[:priority]
  contribution.save
end
# ステータスの変更
post '/change_status/:id' do
  contribution = Contribution.find_by(id: params[:id])
  contribution.status = params[:status]
  contribution.save
end


# 投稿の編集
post '/edit_contribution/:group_id/:contribution_id' do
  contribution = Contribution.find_by(id: params[:contribution_id])
  contribution.body = params[:body]
  contribution.save
  redirect "/group/#{params[:group_id]}"
end

# 投稿の削除
post '/destroy_contribution/:group_id/:contribution_id' do
  # データが見つからなかった時のエラーハンドリングが後々必要
  Contribution.find_by(id: params[:contribution_id]).destroy
  redirect "/group/#{params[:group_id]}"
end

# 投稿の新規作成
post '/create_contribution/:user_id/:group_id' do
  Contribution.create!(
    body: params[:body],
    status: 'new',
    priority: params[:priority],
    user_id: params[:user_id],
    group_id: params[:group_id]
  )
  redirect "group/#{params[:group_id]}"
end

get '/profile/:id' do
  login_required
  @hoge = User.find_by(id: params[:id])
  binding.pry
  erb :profile
end


post '/change_profile/:id' do
  user = User.find_by(id: params[:id])
  user.image = nil
  user.update(
    screen_name: params[:screen_name],
    email: params[:email],
    image: params[:image]
  )
  p params[:image]
  p user.image
  p user.image.url
  user.save!
  binding.pry
  redirect "/profile/#{user.id}"
end