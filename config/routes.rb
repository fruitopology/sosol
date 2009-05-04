ActionController::Routing::Routes.draw do |map|


  map.resources :comments

  map.resources :events

  # map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  # map.login '/login', :controller => 'sessions', :action => 'new'
  # map.register '/register', :controller => 'users', :action => 'create'
  # map.signup '/signup', :controller => 'users', :action => 'new'
  map.resource :session

  map.connect 'articles/list_all', :controller => 'articles', :action => 'list_all'
  map.dashboard 'dashboard', :controller => 'user', :action => 'dashboard'
  
  map.new_from_pn 'articles/new_from_pn', :controller => 'articles', :action => 'new_from_pn'
  map.begin_article  'articles/begin', :controller => 'articles', :action => 'begin'
  #map.connect 'articles/begin', :controller => 'articles', :action => 'begin'
  map.resources :articles, :member => { :editxml => :get, :preview => :get, :comment_on => :get }
  
  map.resources :publications do |publication|
    publication.resources :ddb_identifiers, :member => { :history, :get }
    # publication.resources :identifiers
  end
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.signout 'signout',
    :controller => "user",
    :action => "signout"
    
  map.signin 'signin',
    :controller => "user",
    :action => "signin"
    
  map.account 'account',
    :controller => "user",
    :action => "account"
end
