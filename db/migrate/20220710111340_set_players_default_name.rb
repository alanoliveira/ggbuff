class SetPlayersDefaultName < ActiveRecord::Migration[6.1]
  def change
    change_column :players, :player_name, :string, default: "GG PLAYER"
  end
end
