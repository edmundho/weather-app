Rails.application.routes.draw do
  root to: 'welcome#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    match :weather, to: 'weather#get_weather_info', via: [:get, :post]
  end
end
