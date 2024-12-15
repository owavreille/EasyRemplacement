
class CsvExportService
  def self.amounts_to_csv(totals)
    CSV.generate(headers: true) do |csv|
      csv << ["Période", "Montant Total", "Montant Reversé", "Montant Net"]
      totals[:amount].each do |period, amount|
        csv << [
          period,
          amount,
          totals[:amount_paid][period],
          totals[:amount_earned][period]
        ]
      end
    end
  end

  def self.amounts_by_site_to_csv(totals)
    CSV.generate(headers: true) do |csv|
      csv << ["Site", "Montant Total", "Montant Reversé", "Montant Net"]
      totals[:amount].each do |site_name, amount|
        csv << [
          site_name,
          amount,
          totals[:amount_paid][site_name],
          totals[:amount_earned][site_name]
        ]
      end
    end
  end

  def self.amounts_by_doctor_to_csv(totals)
    CSV.generate(headers: true) do |csv|
      csv << ["Médecin", "Montant Total", "Montant Reversé", "Montant Net"]
      totals[:amount].each do |doctor_name, amount|
        csv << [
          doctor_name,
          amount,
          totals[:amount_paid][doctor_name],
          totals[:amount_earned][doctor_name]
        ]
      end
    end
  end

  def self.amounts_by_user_to_csv(totals)
    CSV.generate(headers: true) do |csv|
      csv << ["Remplaçant", "Montant Total", "Montant Reversé", "Montant Net"]
      totals[:amount].each do |user_name, amount|
        csv << [
          user_name,
          amount,
          totals[:amount_paid][user_name],
          totals[:amount_earned][user_name]
        ]
      end
    end
  end
end
