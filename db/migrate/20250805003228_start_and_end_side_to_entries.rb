class StartAndEndSideToEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :entries, :start_side, :string
    add_column :entries, :end_side, :string
  end
end
