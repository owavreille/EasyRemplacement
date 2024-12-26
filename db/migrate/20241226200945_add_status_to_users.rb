class AddStatusToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :status, :string, default: "Actif"
  end
end
