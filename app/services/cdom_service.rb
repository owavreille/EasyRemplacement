class CdomService
  def self.create_cdom(params)
    Cdom.create!(params)
  end

  def self.update_cdom(cdom, params)
    cdom.update!(params)
  end

  def self.can_destroy?(cdom)
    !cdom.sites.exists?
  end

  def self.find_by_postal_code(postal_code)
    department_code = postal_code[0..1]
    Cdom.find_by("departement LIKE ?", "#{department_code}%")
  end

  def self.notify_contract(cdom, event, contract_content)
    return unless cdom&.email.present?

    NotificationMailer.cdom_contract_notification(
      cdom.email,
      event,
      contract_content
    ).deliver_later
  end
end