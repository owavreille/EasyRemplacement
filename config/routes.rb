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
      put 'inactive', to: 'users#inactive', as: 'inactive'

    end
    collection do
      put 'edit', to: 'users#edit', as: 'edit'
      patch 'update', to: 'users#update', as: 'update'
    end
  end

# Gestion du contrat
post '/events/:id/generate_contract', to: 'contracts#generate_contract', as: 'generate_contract'
get '/events/:id/view_contract', to: 'contracts#view_contract', as: 'view_contract'  
get'/events/:id/open_contract', to: 'contracts#open_contract', as: 'open_contract'  
patch '/events/:id/validate_contract', to: 'contracts#validate_contract', as: 'validate_contract'

# Gestion des évènements
match '/events/:id/booking', to: 'events#booking', via: [:get, :put], as: 'booking_event'
match '/events/:id/cancel_booking', to: 'events#cancel_booking', via: :delete, as: 'cancel_booking_event'
get '/openings', to: 'events#openings', as: 'openings'
patch '/openings/:id', to: 'events#opened', as: 'opened'
patch '/events/:id/paid', to: 'events#paid', as: 'paid'
patch '/events/:id/unpaid', to: 'events#unpaid', as: 'unpaid'
get 'events/:id/download_ics', to: 'events#download_ics', as: 'download_ics_event'

# Suivi des remplacements et suivi par utilisateur
get '/datas', to: 'data#index', as: 'datas', constraints: { format: 'html' }
get '/data.csv', to: 'data#index', format: 'csv', as: 'data_csv'
patch '/data/:id/update_amount', to: 'data#update_amount', as: 'update_amount_data'
get '/userdata', to: 'data#userdata', as: 'userdata', constraints: { format: 'html' }
get '/userdata.csv', to: 'data#userdata', format: 'csv', as: 'userdata_csv'

# Suppression des signatures utilisateurs
delete 'users/:id/delete_signature', to: 'users#delete_signature', as: 'delete_signature'
delete 'users/:id/delete_signature_profile', to: 'users#delete_signature_profile', as: 'delete_signature_profile'

# Activation/désactivation d'un utilisateur
get 'pending', to: 'users#pending'

# Présentation de la structure
get '/office', to: 'office#index', as: 'office'

# Comptabilité
get 'accounting/amounts', to: 'accounting#amounts', as: 'accounting', defaults: { format: 'html' }
get 'accounting/amounts.csv', to: 'accounting#amounts', defaults: { format: 'csv' }
get 'accounting/amounts_by_user', to: 'accounting#amounts_by_user', defaults: { format: 'html' }
get 'accounting/amounts_by_user.csv', to: 'accounting#amounts_by_user', defaults: { format: 'csv' }
get 'accounting/amounts_by_site', to: 'accounting#amounts_by_site', defaults: { format: 'html' }
get 'accounting/amounts_by_site.csv', to: 'accounting#amounts_by_site', defaults: { format: 'csv' }
get 'accounting/amounts_by_doctor', to: 'accounting#amounts_by_doctor', defaults: { format: 'html' }
get 'accounting/amounts_by_doctor.csv', to: 'accounting#amounts_by_doctor', defaults: { format: 'csv' }

# Paramètres de l'Application
get '/app_settings', to: 'app_settings#index', as: 'app_settings'
patch '/app_settings/:id', to: 'app_settings#update', as: 'app_setting'
delete 'app_settings/:id/delete_logo', to: 'app_settings#delete_logo', as: 'delete_logo'

# Récupération de la ville à partir du code postal
get '/postal_codes/get_cities', to: 'postal_codes#get_cities'

end
