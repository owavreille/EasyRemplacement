json.extract! doctor, :id, :title, :last_name, :first_name, :rpps, :speciality, :conventional_sector, :phone, :mail, :signature, :created_at, :updated_at
json.url doctor_url(doctor, format: :json)
json.signature url_for(doctor.signature)
