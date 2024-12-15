module StringUtils
  def self.sanitize_filename(filename)
    filename.strip.tap do |name|
      name.gsub!(/[^\w\s-]/, '')
      name.gsub!(/\s+/, '-')
      name.downcase!
    end
  end

  def self.truncate(text, length: 30, omission: '...')
    return text unless text && text.length > length
    text[0...(length - omission.length)] + omission
  end

  def self.format_phone(phone)
    return phone unless phone
    phone.gsub(/(\d{2})(?=\d)/, '\1 ').strip
  end
end