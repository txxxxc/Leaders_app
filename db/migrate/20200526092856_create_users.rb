# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password, null: false
      t.string :role, null: false, default: 'member'
      t.string :image, null: false, default: '/img/person.svg'
      t.timestamps null: false
    end
  end
end
