# frozen_string_literal: true

class CreateContributions < ActiveRecord::Migration[5.2]
  def change
    create_table :contributions do |t|
      t.string :body, null: false
      t.string :image
      t.string :status, null: false
      t.string :priority, null: false
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.timestamps null: false
    end
  end
end
