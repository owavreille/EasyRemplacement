class CreateAppSettings < ActiveRecord::Migration[7.0]
def change
  create_table :app_settings do |t|
    t.string :app_name
    t.integer :disable_booking_threshold
    t.integer :max_replacement_cancel
    t.datetime :am_pm_hour_separation
    t.datetime :minimal_replacement_length

    t.timestamps
  end
end
end