class ContractService
  def self.generate_contract(event)
    return false unless can_generate?(event)

    contract_content = ContractGenerator.new(event).generate
    attach_contract(event, contract_content)
    
    event.update!(contract_generated: true)
    true
  end

  def self.validate_contract(event)
    return false unless event.contract_blob.attached?
    
    event.update!(contract_validated: true)
    NotificationMailer.contract_validated(event).deliver_later if event.site.cdom&.email
    true
  end

  private

  def self.can_generate?(event)
    event.user_id.present? && !event.contract_generated
  end

  def self.attach_contract(event, content)
    temp_file = Tempfile.new(['contract', '.html'])
    temp_file.write(content)
    temp_file.rewind

    event.contract_blob.attach(
      io: temp_file,
      filename: "contract_#{event.id}.html",
      content_type: 'text/html'
    )
  ensure
    temp_file&.close
    temp_file&.unlink
  end
end