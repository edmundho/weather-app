# Weather App

Clone the repo:

```bash
git clone git@github.com:edmundho/weather-app.git
```

or

```bash
git clone https://github.com/edmundho/weather-app.git
```

Install gems:

```bash
bundle
```

Launch the server:

```bash
rails s
```

Open <http://localhost:3000> in a browser.

## Using the app

Type in an address (zip code required) on the home page and click submit.
![](public/screenshots/home-page.png)

See your forecast (data not cached).
![](public/screenshots/forecast-no-cache.png)

Click back, and submit again with the same address and see cached data.
![](public/screenshots/forecast-cached.png)

### Notes

The app uses two external APIs:

- The `us-zip-code-latitude-and-longitude` dataset via the public Open Data Soft API takes in a US zip code and returns its corresponding latitude & longitude.
- The lat/lon are then passed to the OpenWeatherMap "One Call API" which returns current weather and 7 day forecast.
- Only the OpenWeatherMap API requires an API key.
- Caching is done with the out-of-the-box Rails memory store (`ActiveSupport::Cache::MemoryStore`)
