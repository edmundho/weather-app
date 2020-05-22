module Api
  class WeatherController < ApplicationController
    skip_before_action :verify_authenticity_token
    include ApiUtils

    def get_weather_info
      zip_code = /\d{5}(?!.*\d)/.match(params[:street])

      zip_data = get_zip_data(zip_code)
      weather_info = get_aggregate_info(zip_data[:lat], zip_data[:lon]).merge({
        location: zip_data
      })

      render json: weather_info
    end
  end
end