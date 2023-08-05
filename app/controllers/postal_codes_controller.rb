class PostalCodesController < ApplicationController
    include PostalCodeApi
  
    def get_cities
      postal_code = params[:postal_code]
      cities = fetch_cities(postal_code)
      render json: cities
    end
  end