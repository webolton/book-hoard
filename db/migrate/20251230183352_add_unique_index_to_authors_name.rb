# frozen_string_literal: true

class AddUniqueIndexToAuthorsName < ActiveRecord::Migration[8.0]
  def change
    add_index :authors, [:first_name, :last_name], unique: true
  end
end
