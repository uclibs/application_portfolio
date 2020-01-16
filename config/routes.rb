# frozen_string_literal: true

# frozen_string_literal: true*

Rails.application.routes.draw do
  devise_for :users
  resources :vendor_records
  resources :software_types
  resources :software_records
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'front#index'
  get 'about', to: 'front#about'
  get 'contact', to: 'front#contact'
  get 'request/new', to: 'front#new'
  post 'request', to: 'front#create'
  get 'myprofile', to: 'front#profile'
  get 'dashboard', to: 'front#dashboard'
  get 'users', to: 'users#index', as: 'users'
  get 'users/:id', to: 'users#show', as: 'users_show'
  get 'users/:id/edit', to: 'users#edit', as: 'user_edit'
  delete 'users/:id', to: 'users#destroy', as: 'user_destroy'
  post 'users/:id/edit', to: 'users#update', as: 'user_update'
  get 'users/:id/status', to: 'users#user_status', as: 'user_status'
end
