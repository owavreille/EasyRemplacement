class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? && !options[:required]
    
    unless valid_phone_format?(value)
      record.errors.add(attribute, options[:message] || "n'est pas un numéro de téléphone valide")
    end
  end

  private

  def valid_phone_format?(phone)
    phone.present? && 
    phone.match?(/\A(?:(?:\+|00)33|0)\s*[1-9](?:[\s.-]*\d{2}){4}\z/)
  end
end