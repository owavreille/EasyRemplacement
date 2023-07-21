class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :site, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.integer :number_of_patients
      t.boolean :helper
      t.references :user, null: true, foreign_key: true
      t.decimal :amount
      t.decimal :reversion, default: 70
      t.decimal :amount_paid
      t.boolean :contract_generated
      t.boolean :contract_validated
      t.boolean :opened
      t.boolean :editable
      t.integer :patient_count
      t.datetime :am_min_hour
      t.datetime :am_max_hour
      t.datetime :pm_min_hour
      t.datetime :pm_max_hour
      t.references :contract_blob, polymorphic: true

      t.timestamps
    end
  end
end
