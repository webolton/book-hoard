class AddAliasToAuthors < ActiveRecord::Migration[8.0]
  def change
    add_column :authors, :alias_name, :string
  end
end
