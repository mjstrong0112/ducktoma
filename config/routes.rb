Ducktoma::Application.routes.draw do
  devise_for :users, :path => 'accounts'

  get "home/index"

  root :to => "adoptions#new"

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
    match "/adoptions/export" => "adoptions#export_csv"
    match "/adoptions/find_duplicates" => 'adoptions#find_duplicates', :as => :find_duplicates
    post "/adoptions/remove_duplicates" => 'adoptions#remove_duplicates', :as => :remove_duplicates
    
    resources :adoptions, :only => :index
    # Redirect admin show to standard show.
    match "/adoptions/:id" => redirect("/adoptions/%{id}")
  end
  
  resources :adoptions, :except => :show
  get '/adoptions/:id' => 'adoptions#show', :as => :adoption, :constraints => { :id => /\w{24}/ }
  get '/adoptions/:adoption_number' => 'adoptions#show', :as => :adoption

  resources :payment_notifications



  match 'adoptions/number/:adoption_number' => 'adoptions#show'
end
