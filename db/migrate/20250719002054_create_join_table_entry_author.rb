class CreateJoinTableEntryAuthor < ActiveRecord::Migration[8.0]
  def change
    create_join_table :entries, :authors do |t|
      t.index [:entry_id, :author_id]
      t.index [:author_id, :entry_id]
    end
  end
end
