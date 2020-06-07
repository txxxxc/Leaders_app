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

  def login_required
    redirect '/login' if session[:user_id].nil?
  end

  def logout_required
    p session[:user_id]
    redirect '/' if session[:user_id]
  end
end

before do
  @logged_in = logged_in?
  @user = current_user if @logged_in
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
get '/give_permisson/:id' do
  login_required
end

# グループ作成画面
get '/create_group' do
  login_required
end

# グループ画面
get '/group/:id' do
  login_required
  @group = Group.find_by(id: params[:id])
  @group_users = @group.users
  @contributions = @group.contributions
  @page_title = @group.name
  erb :group
end

# 投稿画面
get '/create_contribution' do
  login_required
end

# 投稿編集画面
get '/edit_contribution/:id' do
  login_required
end

# 投稿削除画面
get '/confirm_destroy_contribution/:id' do
  login_required
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
post '/give_permisson/:id' do

end

# グループの作成
post '/create_group' do

end

# ユーザーをグループへ招待
post '/invite_user/:id' do

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
post '/edit_contribution/:id' do

end

# 投稿の削除
post '/destroy_contribution/:id' do

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