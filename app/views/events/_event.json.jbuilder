json.extract! event, :id, :site_id, :doctor_id, :start_time, :end_time, :number_of_patients, :helper, :user_id, :amount, :reversion, :created_at, :updated_at
json.url event_url(event, format: :json)
