class DoctorManagementService
  def self.create_doctor(params)
    Doctor.create!(params)
  end

  def self.update_doctor(doctor, params)
    doctor.update!(params)
  end

  def self.handle_signature_upload(doctor, signature_file)
    return false unless signature_file

    if doctor.signature.attached?
      doctor.signature.purge
    end

    doctor.signature.attach(signature_file)
  end

  def self.remove_signature(doctor)
    return false unless doctor.signature.attached?
    doctor.signature.purge
  end

  def self.can_destroy?(doctor)
    !doctor.events.exists?
  end
end