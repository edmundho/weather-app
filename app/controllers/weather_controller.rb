class WeatherController < ApplicationController
  skip_before_action :verify_authenticity_token
  include ApiUtils

  def get_weather_info
    zip_code = /\d{5}(?!.*\d)/.match(params[:street])

    zip_data = get_zip_data(zip_code)

    cached_data = Rails.cache.read(zip_code)

    if cached_data
      @weather_info = cached_data.merge({ cached: true })
    else
      @weather_info = get_aggregate_info(zip_data[:lat], zip_data[:lon]).merge({
        location: zip_data,
        cached: false
      })
      Rails.cache.write(zip_code, @weather_info, expires_in: 30.minutes)
    end

    p @weather_info
  end
end
