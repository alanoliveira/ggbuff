class AddMatchLoaderProcessIdToMatch < ActiveRecord::Migration[6.1]
  def change
    add_reference :matches, :match_load_process, null: false, foreign_key: true
  end
end
