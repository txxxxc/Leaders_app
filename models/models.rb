# frozen_string_literal: true

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3:db/development.db')
class User < ApplicationRecord
  has_many :groups, through: :user_groups
  has_many :user_groups
  has_many :contributions
end

class Group < ApplicationRecord
  has_many :users, through: :user_groups
  has_many :user_groups
  has_many :contributions
  accepts_nested_attributes_for :user_groups
end

class Contribution < ApplicationRecord
  belongs_to :user
  belongs_to :group
end

class UserGroups < ApplicationRecord
  belongs_to :user
  belongs_to :group
end
