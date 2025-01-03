class CreateSites < ActiveRecord::Migration[7.0]
  def change
    create_table :sites do |t|
      t.string :name
      t.string :address
      t.string :postal_code
      t.string :city
      t.string :email
      t.string :phone
      t.string :software
      t.text :informations
      t.text :instructions
      t.references :cdom, foreign_key: true
      t.string :color
      t.integer :min_patients
      t.integer :max_patients
      t.integer :min_patients_helped
      t.integer :max_patients_helped
      t.datetime :am_min_hour
      t.datetime :am_max_hour
      t.datetime :pm_min_hour
      t.datetime :pm_max_hour
      t.datetime :min_lenght

      t.timestamps
    end
  end
end
