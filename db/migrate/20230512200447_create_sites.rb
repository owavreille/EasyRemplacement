class CreateSites < ActiveRecord::Migration[7.0]
  def change
    create_table :sites do |t|
      t.string :name
      t.string :address
      t.string :postal_code
      t.string :city
      t.string :software
      t.text :informations
      t.references :cdom, null: false, foreign_key: true
      t.string :color
      t.integer :min_patients
      t.integer :max_patients
      t.integer :min_patients_helped
      t.integer :max_patients_helped
      t.integer :am_min_hour
      t.integer :am_max_hour
      t.integer :pm_min_hour
      t.integer :pm_max_hour

      t.timestamps
    end
  end
end
