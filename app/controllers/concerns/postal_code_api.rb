module PostalCodeApi
  extend ActiveSupport::Concern

  def fetch_cities(postal_code)
    response = Faraday.get("https://apicarto.ign.fr/api/codes-postaux/communes/#{postal_code}")
    JSON.parse(response.body)
  end
end
