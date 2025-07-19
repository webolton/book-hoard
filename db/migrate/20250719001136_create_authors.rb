# frozen_string_literal: true

class CreateAuthors < ActiveRecord::Migration[8.0]
  def change
    create_table :authors do |t|
      t.string :first_name
      t.string :last_name
      t.string :additional_information
      t.timestamps
    end
  end
end
