class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :card_background

      t.timestamps null: false
    end
  end
end
