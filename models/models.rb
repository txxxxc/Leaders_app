# frozen_string_literal: true

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3:db/development.db')
class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  has_many :groups, through: :user_groups
  has_many :user_groups
  has_many :contributions
  validates :name, presence: true, length: { in: 2..50 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true
  validates :role, presence: true
end

class Group < ActiveRecord::Base
  has_many :users, through: :user_groups
  has_many :user_groups
  has_many :contributions
  accepts_nested_attributes_for :user_groups
end

class Contribution < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
end

class UserGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
end
