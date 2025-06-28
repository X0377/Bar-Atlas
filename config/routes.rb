Rails.application.routes.draw do
  resources :specialties

  root 'bars#index'

  resources :bars, only: [:index, :show]

  get "up" => "rails/health#show", as: :rails_health_check
end
