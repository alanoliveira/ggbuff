class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.references :store, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.references :opponent, null: true, foreign_key: {to_table: "players"}
      t.integer :player_char, null: false
      t.integer :opponent_char, null: false
      t.integer :player_rank, null: true
      t.integer :opponent_rank, null: true
      t.integer :result, null: false
      t.integer :rank_change
      t.datetime :played_at, null: false

      t.timestamps
    end

    add_index :matches, :player_char
    add_index :matches, :opponent_char
    add_index :matches, :player_rank
    add_index :matches, :opponent_rank
    add_index :matches, :result
  end
end

