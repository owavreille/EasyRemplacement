Rails.application.routes.draw do
  # Root path
  root "events#index"

  # Authentication
  devise_for :users, controllers: { 
    registrations: 'registrations', 
    sessions: 'users/sessions', 
    omniauth_callbacks: 'users/omniauth_callbacks' 
  }

  # Resources
  resources :events do
    resource :booking, only: [:create, :destroy]
  end
  resources :cdoms
  resources :mailing_lists
  resources :contracts, only: [:index] do
    patch 'update_contract', on: :collection
  end
  resources :doctors
  resources :sites
  resources :users do
    member do
      delete '/', to: 'users#destroy', as: 'destroy'
      put 'active', to: 'users#active', as: 'active'
      put 'inactive', to: 'users#inactive', as: 'inactive'
    end
  end

   # Download ICS
   resources :events do
    member do
      get :download_ics
    end
    resource :booking, only: [:create, :destroy]
  end

  # Contract management
  post '/events/:id/generate_contract', to: 'contracts#generate_contract', as: 'generate_contract'
  get '/events/:id/view_contract', to: 'contracts#view_contract', as: 'view_contract'  
  get '/events/:id/open_contract', to: 'contracts#open_contract', as: 'open_contract'  
  patch '/events/:id/validate_contract', to: 'contracts#validate_contract', as: 'validate_contract'

  # Event management
  get '/openings', to: 'events#openings', as: 'openings'
  patch '/openings/:id', to: 'events#opened', as: 'opened'
  patch '/events/:id/paid', to: 'events#paid', as: 'paid'
  patch '/events/:id/unpaid', to: 'events#unpaid', as: 'unpaid'

  # Data management
  get '/datas', to: 'data#index', as: 'datas', constraints: { format: 'html' }
  get '/data.csv', to: 'data#index', format: 'csv', as: 'data_csv'
  patch '/data/:id/update_amount', to: 'data#update_amount', as: 'update_amount_data'
  patch '/data/:id/paid', to: 'data#paid', as: 'data_paid'
  get '/userdata', to: 'data#userdata', as: 'userdata', constraints: { format: 'html' }
  get '/userdata.csv', to: 'data#userdata', format: 'csv', as: 'userdata_csv'

  # User management
  delete 'users/:id/delete_signature', to: 'users#delete_signature', as: 'delete_signature'
  delete 'users/:id/delete_signature_profile', to: 'users#delete_signature_profile', as: 'delete_signature_profile'
  get 'pending', to: 'users#pending'
  get '/office', to: 'office#index', as: 'office'

  # Accounting
  get 'accounting/amounts', to: 'accounting#amounts', as: 'accounting'
  get 'accounting/amounts_by_user', to: 'accounting#amounts_by_user'
  get 'accounting/amounts_by_site', to: 'accounting#amounts_by_site'
  get 'accounting/amounts_by_doctor', to: 'accounting#amounts_by_doctor'

  # Settings
  get '/app_settings', to: 'app_settings#index', as: 'app_settings'
  patch '/app_settings/:id', to: 'app_settings#update', as: 'app_setting'
  delete 'app_settings/:id/delete_logo', to: 'app_settings#delete_logo', as: 'delete_logo'

  # API
  get '/postal_codes/get_cities', to: 'postal_codes#get_cities'
end