# frozen_string_literal: true

require 'bundler/setup'
Bundler.require
require 'sinatra'
require 'sinatra/reloader' if development?
require './models/models.rb'
require 'pry'


# *** get ***

# ホーム画面
get '/' do
  @user = User.first
  @group = Group.first
  @contribution = Contribution.first
  binding.pry
  erb :index
end

# 新規登録画面
get '/signup' do

end

# ログイン画面
get '/signin' do

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

end

# ログイン
post '/signin' do

end

# ログアウト
post '/logout' do

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
