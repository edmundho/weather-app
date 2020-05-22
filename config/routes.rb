Rails.application.routes.draw do
  root to: 'welcome#index'
  match :weather, to: 'weather#get_weather_info', via: [:post]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
