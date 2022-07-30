class AddLastLoginToPlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :last_login_at, :datetime
  end
end
