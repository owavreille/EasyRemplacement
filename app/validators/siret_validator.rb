class SiretValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? && !options[:required]
    
    unless valid_siret?(value)
      record.errors.add(attribute, options[:message] || "n'est pas un numéro SIRET valide")
    end
  end

  private

  def valid_siret?(siret)
    return false unless siret.match?(/^\d{14}$/)
    
    # Algorithme de Luhn pour la validation du SIRET
    sum = 0
    siret.reverse.each_char.with_index do |digit, i|
      n = digit.to_i
      n *= 2 if i.odd?
      n = n > 9 ? n - 9 : n
      sum += n
    end
    
    (sum % 10).zero?
  end
end