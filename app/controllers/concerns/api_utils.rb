module ApiUtils
  def get_zip_data(zip_code)
    url = "https://public.opendatasoft.com/api/records/1.0/search/?dataset=us-zip-code-latitude-and-longitude&q=#{zip_code}"
    response = RestClient.get(url)
    data = JSON.parse(response)['records'][0]['fields']
    {
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

  def extract_current_weather(data)
    {
      current_temp: convert_to_degf(data['temp']),
      feels_like: convert_to_degf(data['feels_like']),
      condition: data['weather'][0]['main'],
      date: Time.at(data['dt']).to_date
    }
  end

  def extract_forecast_data(data)
    forecast = []
    data.each do |day|
      date = Time.at(day['dt']).to_date
      forecast << {
        date: date,
        high: convert_to_degf(day['temp']['max']),
        low: convert_to_degf(day['temp']['min']),
        condition: day['weather'][0]['main']
      }
    end
    forecast
  end

  def convert_to_degf(float)
    ((float - 273.15) * Rational(9, 5) + 32).round
  end
end