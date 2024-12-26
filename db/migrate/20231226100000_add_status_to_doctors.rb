class AddStatusToDoctors < ActiveRecord::Migration[7.1]
  def change
    add_column :doctors, :status, :string, default: 'Disponible', null: false
    add_index :doctors, :status
  end
end 