module Api
  class WeatherController < ApplicationController
    skip_before_action :verify_authenticity_token

    def get_weather_info
      zip_code = /\d{5}(?!.*\d)/.match(params[:street])

      address_data = location_data(zip_code)
      weather_info = get_aggregate_info(address_data[:lat], address_data[:lon]).merge({
        location: address_data
      })

      render json: weather_info
    end

    def location_data(zip)
      url = "https://public.opendatasoft.com/api/records/1.0/search/?dataset=us-zip-code-latitude-and-longitude&q=#{zip}"
      body = RestClient.get(url)
      data = JSON.parse(body)['records'][0]['fields']
      coords = {
        lat: data['geopoint'][0],
        lon: data['geopoint'][1],
        zip: data['zip'],
        city: data['city'],
        state: data['state']
      }
    end

    def get_aggregate_info(lat, lon)
      api_key = ENV['OWM_KEY']
      url = "https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{lon}&exclude=hourly,minutely&appid=#{api_key}"
      body = RestClient.get(url)
      data = JSON.parse(body)
      current_weather = data['current']
      forecast = data['daily']
      {
        current_weather: extract_current_weather(current_weather),
        forecast: extract_forecast_data(forecast)
      }
    end
  end
end