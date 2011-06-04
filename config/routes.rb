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
    get '/ducks/regenerate' => 'ducks#regenerate', :as => :regenerate_ducks
    match '/ducks/:number' => "ducks#show"

    root :to => "dashboard#index"
    resources :adoptions
    resources :users
    resources :locations
    resources :organizations
    resources :pricings
    match "/payment_notifications/failed" => "payment_notifications#failed"
    resources :payment_notifications
    resource :settings

    match '/invalidate_adoptions/confirm' => "invalidate_adoptions#confirm", :as => :confirm_invalidation
    match '/invalidate_adoptions' => "invalidate_adoptions#index", :as => :invalidate_adoptions
    match '/invalidate_adoptions/invalidate' => "invalidate_adoptions#invalidate", :as => :invalidate_adoption
  end
  
  resources :adoptions
  resources :payment_notifications

  match 'adoptions/number/:adoption_number' => 'adoptions#show'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
