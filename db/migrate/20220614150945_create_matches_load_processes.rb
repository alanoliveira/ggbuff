class CreateMatchesLoadProcesses < ActiveRecord::Migration[6.1]
  def change
    create_table :matches_load_processes do |t|
      t.integer :state, default: 0
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
