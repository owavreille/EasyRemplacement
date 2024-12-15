
module ValidationUtils
  def self.valid_email?(email)
    email =~ URI::MailTo::EMAIL_REGEXP
  end

  def self.valid_date?(date_string)
    Date.parse(date_string.to_s)
    true
  rescue ArgumentError
    false
  end

  def self.valid_time?(time_string)
    Time.parse(time_string.to_s)
    true
  rescue ArgumentError
    false
  end

  def self.valid_number?(number)
    Float(number)
    true
  rescue ArgumentError, TypeError
    false
  end

  def self.valid_percentage?(value)
    valid_number?(value) && value.to_f.between?(0, 100)
  end
end
