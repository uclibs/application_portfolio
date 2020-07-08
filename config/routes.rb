# frozen_string_literal: true

Rails.application.routes.draw do
  get 'seed/new', to: 'file_uploads#new', as: 'file_uploads_new'
  get 'seed/create', to: 'file_uploads#create', as: 'file_uploads_create'
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
  get '/search' => 'front#search'
  get 'users', to: 'users#index', as: 'users'
  get 'users/:id', to: 'users#show', as: 'users_show'
  get 'users/:id/edit', to: 'users#edit', as: 'user_edit'
  delete 'users/:id', to: 'users#destroy', as: 'user_destroy'
  post 'users/:id/edit', to: 'users#update', as: 'user_update'
  get 'users/:id/status', to: 'users#user_status', as: 'user_status'
  get 'export/software_records', to: 'export_data#software_records', as: 'export_software_records'
  get 'export/vendor_records', to: 'export_data#vendor_records', as: 'export_vendor_records'
  get 'export/software_types', to: 'export_data#software_types', as: 'export_software_types'

  resources :file_uploads, only: %i[new create]
end
