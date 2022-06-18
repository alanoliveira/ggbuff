class AddErrorToMatchesLoadProcesses < ActiveRecord::Migration[6.1]
  def change
    add_column :matches_load_processes, :error_description, :string
  end
end
