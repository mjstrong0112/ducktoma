Ducktoma::Application.routes.draw do

  devise_for :club_members, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  devise_for :users
  root :to => "adoptions#new"

  resources :adoptions, :except => :show  
  get '/adoptions/:id/associate/:user_id' => "adoptions#associate", :as => :associate_user_to_adoption
  get '/adoptions/:adoption_number' => 'adoptions#show', :as => :adoption, :constraints => { :adoption_number => /[^\D]{5,}/ }
  get '/adoptions/:id' => 'adoptions#show', :as => :adoption
  match 'adoptions/number/:adoption_number' => 'adoptions#show'
  resources :payment_notifications


  match 'top', to: "club_members#index", as: :top_contributors
  # -----------------
  # Facebook Omniauth
  # -----------------
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  match '/profile' => "club_members#show"

  get 'club_members/autocomplete_name/:name' => "club_members#autocomplete_name", as: :club_members_autocomplete_name
  resources :club_members do
    get :share_to_wall, on: :member
    get :approve, on: :member
    get :unapprove, on: :member
  end

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

    resources :club_members

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

    resources :sales_events, :only => [:index, :show, :edit, :update] do
      member do
        match 'move'
        match 'reassign'
      end
    end
  end

end
