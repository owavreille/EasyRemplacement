class UserManagementService
  def self.activate_user(user)
    user.update(active: true)
  end

  def self.deactivate_user(user)
    user.update(active: false)
  end

  def self.update_user(user, params)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    user.update(params)
  end

  def self.handle_signature_upload(user, signature_file)
    return false unless signature_file

    if user.signature.attached?
      user.signature.purge
    end

    user.signature.attach(signature_file)
  end

  def self.remove_signature(user)
    return false unless user.signature.attached?
    user.signature.purge
  end
end