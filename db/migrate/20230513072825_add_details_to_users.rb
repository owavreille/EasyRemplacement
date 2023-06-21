class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :title, :string
    add_column :users, :role, :boolean, default: false
    add_column :users, :last_name, :string
    add_column :users, :first_name, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :phone, :string
    add_column :users, :address, :string
    add_column :users, :postal_code, :string
    add_column :users, :city, :string
    add_column :users, :siret_number, :string
    add_column :users, :license_number, :string
    add_reference :users, :mailing_list, foreign_key: true
    add_column :users, :active, :boolean
    add_column :users, :uid, :string
    add_column :users, :provider, :string

    change_table :users do |t|
      t.bigint :signature_blob_id
    end
    
    add_foreign_key :users, :active_storage_blobs, column: :signature_blob_id
    add_index :users, :signature_blob_id, unique: true
    
  end
end
