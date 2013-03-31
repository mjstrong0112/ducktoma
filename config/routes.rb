Ducktoma::Application.routes.draw do

  devise_for :users
  root :to => "adoptions#new"

  resources :adoptions, :except => :show
  get '/adoptions/:id' => 'adoptions#show', :as => :adoption, :constraints => { :id => /[^\D]+/ }
  get '/adoptions/:adoption_number' => 'adoptions#show', :as => :adoption
  match 'adoptions/number/:adoption_number' => 'adoptions#show'
  resources :payment_notifications

  # -----------------
  # Facebook Omniauth
  # -----------------
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'


  resources :users do
    resources :adoptions
  end

  namespace :sales do
    root :to => "dashboard#index"
    resources :adoptions
    resources :sales_events do
      resources :adoptions
    end
    match "/new" => "sales_events#new"
  end
  
  namespace :admin do
    root :to => "dashboard#index"
    resources :users
    resources :locations
    resources :organizations
    resources :pricings
    resource :settings

    match "/payment_notifications/failed" => "payment_notifications#failed"
    resources :payment_notifications

    # --------------------
    # Invalidate Adoptions
    # --------------------
    match '/invalidate_adoptions/confirm' => "invalidate_adoptions#confirm", :as => :confirm_invalidation
    match '/invalidate_adoptions' => "invalidate_adoptions#index", :as => :invalidate_adoptions
    match '/invalidate_adoptions/invalidate' => "invalidate_adoptions#invalidate", :as => :invalidate_adoption

    # ------------
    # Duck actions
    # ------------
    get '/ducks/regenerate' => 'ducks#regenerate', :as => :regenerate_ducks
    get '/ducks/:number' => "ducks#show"

    # ------------------
    # Adoptions actions.
    # ------------------
    match "/adoptions/export_by_name" => "adoptions#export_by_name"
    match "/adoptions/export_by_adoption_number" => "adoptions#export_by_adoption_number"
    match "/adoptions/export_by_duck_number" => "adoptions#export_by_duck_number"
    match "/adoptions/find_duplicates" => 'adoptions#find_duplicates', :as => :find_duplicates
    post "/adoptions/remove_duplicates" => 'adoptions#remove_duplicates', :as => :remove_duplicates
    
    resources :adoptions, :only => :index
    # Redirect admin show to standard show.
    match "/adoptions/:id" => redirect("/adoptions/%{id}")

    resources :sales_events, :only => [:index, :show] do
      member do
        match 'move'
        match 'reassign'
      end
    end
  end

end
