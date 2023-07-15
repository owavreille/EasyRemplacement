Rails.application.routes.draw do

# Defines the root path route ("/")
root "events#index"

  get 'users/new'
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'users/sessions', omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :cdoms
  patch '/cdoms/:id', to: 'cdoms#update', as: 'update' 
  delete '/cdoms/:id', to: 'cdoms#destroy', as: 'destroy'

  resources :mailing_lists
  resources :contracts, only: [:index] do
    patch 'update_contract', on: :collection
  end
  resources :events 
  resources :doctors
  resources :sites
  resources :users do
    member do
      delete '/', to: 'users#destroy', as: 'destroy'
      put 'active', to: 'users#active', as: 'active'
    end
    collection do
      put 'edit', to: 'users#edit', as: 'edit'
      patch 'update', to: 'users#update', as: 'update'
    end
  end

# Gestion du contrat
post '/events/:id/generate_contract', to: 'data#generate_contract', as: 'generate_contract'
get '/events/:id/download_contract', to: 'data#download_contract', as: 'download_contract'  
patch '/events/:id/validate_contract', to: 'data#validate_contract', as: 'validate_contract'

# Gestion des évènements
match '/events/:id/booking', to: 'events#booking', via: [:get, :put], as: 'booking_event'
match '/events/:id/cancel_booking', to: 'data#cancel_booking', via: :delete, as: 'cancel_booking_event'
get '/list', to: 'events#list', as: 'list'

# Suivi des remplacements et suivi par utilisateur
get '/datas', to: 'data#index', as: 'datas'
patch '/data/:id/update_amount', to: 'data#update_amount', as: 'update_amount_data'
get '/userdata', to: 'data#userdata', as: 'userdata'

# Suppression des signatures utilisateurs
delete 'users/:id/delete_signature', to: 'users#delete_signature', as: 'delete_signature'
delete 'users/:id/delete_signature_profile', to: 'users#delete_signature', as: 'delete_signature_profile'

# Activation/désactivation d'un utilisateur
get '/inactive', to: 'users#inactive', as: 'inactive'
get 'users/:id/inactive', to: 'users#inactive', as: 'inactive_user'

# Présentation de la structure
get '/office', to: 'office#index', as: 'office'

# Comptabilité
get '/accounting', to: 'accounting#index', as: 'accounting'

# Paramètres de l'Application
get '/app_settings', to: 'app_settings#index', as: 'app_settings'
patch '/app_settings/1/update_app_settings', to: 'app_settings#update_app_settings', as: 'update_app_settings'

end
