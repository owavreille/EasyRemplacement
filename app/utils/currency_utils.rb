module CurrencyUtils
  def self.format_amount(amount, currency: '€')
    return '0,00 €' if amount.nil?
    
    formatted = sprintf('%.2f', amount)
    formatted.gsub!('.', ',')
    "#{formatted} #{currency}"
  end

  def self.format_percentage(value)
    return '0%' if value.nil?
    
    formatted = sprintf('%.1f', value)
    formatted.gsub!('.', ',')
    "#{formatted}%"
  end

  def self.calculate_amount_with_tax(amount, tax_rate)
    return 0 if amount.nil? || tax_rate.nil?
    amount * (1 + tax_rate / 100.0)
  end

  def self.calculate_tax_amount(amount, tax_rate)
    return 0 if amount.nil? || tax_rate.nil?
    amount * (tax_rate / 100.0)
  end
end