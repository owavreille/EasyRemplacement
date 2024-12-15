module DataHelper
    def format_date(date)
      date.strftime("%d/%m/%Y")
    end
  
    def format_time(time)
      time.strftime("%H:%M")
    end
  
    def format_doctor_name(doctor)
      "Dr #{doctor.first_name} #{doctor.last_name}"
    end
  
    def format_boolean(value)
      value ? "oui" : "non"
    end
  
    def format_amount(amount)
      number_to_currency(amount, unit: "€", separator: ",", delimiter: " ")
    end
  
    def format_percentage(value)
      "#{value}%"
    end
  end