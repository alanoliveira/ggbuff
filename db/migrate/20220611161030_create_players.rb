class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :player_name
      t.integer :ggxrd_user_id, null: false

      t.timestamps
    end
    add_index :players, :player_name
    add_index :players, :ggxrd_user_id, unique: true
  end
end
