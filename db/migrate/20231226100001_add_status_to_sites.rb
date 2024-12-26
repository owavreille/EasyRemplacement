class AddStatusToSites < ActiveRecord::Migration[7.1]
  def change
    add_column :sites, :status, :string, default: 'Ouvert', null: false
    add_index :sites, :status
  end
end 