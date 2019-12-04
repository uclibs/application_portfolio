# frozen_string_literal: true

Rails.application.routes.draw do
  resources :software_types
  resources :vendor_records
  resources :software_records
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'front#index'
  get '/dashboard', to: 'front#dashboard'
end
