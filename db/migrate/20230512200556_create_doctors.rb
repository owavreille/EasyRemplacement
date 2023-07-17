class CreateDoctors < ActiveRecord::Migration[7.0]
  def change
    create_table :doctors do |t|
      t.string :title
      t.string :last_name
      t.string :first_name
      t.string :rpps
      t.string :speciality
      t.string :conventional_sector
      t.boolean :optam
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
