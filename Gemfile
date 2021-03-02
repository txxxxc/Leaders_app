# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.6.6'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'sinatra', '~> 2.0'

gem 'sinatra-contrib', '~> 2.0'

gem 'sinatra-activerecord'

gem 'rake'

gem 'activerecord', '5.2.4.5'

gem "bcrypt", "~> 3.1"

gem "carrierwave", "~> 2.1"

gem "mini_magick", "~> 4.10"

gem "sinatra-flash", "~> 0.3.0"

gem "rack-flash3", "~> 1.0"

group :development do
  gem 'pry'
  gem 'rubocop'
  gem 'rubocop-config-prettier'
  gem 'rubocop-performance'
  gem 'sqlite3', '~> 1.4.1'
end

group :production do
  gem 'pg' , '0.21.0'
end