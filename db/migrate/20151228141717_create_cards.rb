class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :background
      t.string :face
      t.string :eye
      t.string :eyebrow
      t.string :hair
      t.string :nose
      t.string :mouth

      t.integer :game_id

      t.timestamps null: false
    end
    add_foreign_key :games, :cards
  end
end
