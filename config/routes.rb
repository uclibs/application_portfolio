# frozen_string_literal: true

Rails.application.routes.draw do
  resources :change_requests
  resources :hosting_environments
  resources :statuses

  get 'seed/new', to: 'file_uploads#new', as: 'file_uploads_new'
  get 'seed/create', to: 'file_uploads#create', as: 'file_uploads_create'
  devise_for :users

  resources :vendor_records
  resources :software_types
  resources :software_records
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'front#index'
  get 'list_upgrades' => 'software_records#list_upgrades'
  get 'list_road_map' => 'software_records#list_road_map'
  get 'list_decommissioned' => 'software_records#list_decommissioned'

  resources :software_records do
    member do
      get 'edit_road_map'
      patch 'update_road_map'
    end
  end

  resources :software_records do
    member do
      get 'edit_decommissioned'
      patch 'update_decommissioned'
    end
  end

  #  get 'software_records/:id/edit_roadmap', to: 'software_records#edit_road_map', as: 'edit_road_map_software_record'
  get 'edit_road_map_software_records' => 'software_records#list_road_map'
  get 'edit_decommissioned_software_records' => 'software_records#list_decommissioned'
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
  get 'export/change_requests', to: 'export_data#change_requests', as: 'export_change_requests'

  resources :file_uploads, only: %i[new create]
end
