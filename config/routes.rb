Rails.application.routes.draw do
  resources :players, :items
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'players#index'
  get 'index' => 'players#index'
  get 'ranks' => 'players#ranks'
  get 'ehp' => 'players#ehp'
  get 'fake' => 'players#fake'
  get 'possible_fakes' => 'players#possible_fakes'
  get 'links' => 'players#links'
  get 'changelog' => 'players#changelog'
  get 'oldchangelog' => 'players#oldchangelog'
  get 'donate' => 'players#donate'
  get 'controls' => 'players#controls'
  get 'plaintext' => 'players#plaintext'
  get 'tracking_plaintext' => 'players#tracking_plaintext'
  get 'names' => 'players#names'
  get 'dps' => 'players#dps'
  get 'combat' => 'players#combat'
  get 'calcs' => 'players#calcs'
  get 'gpxp' => 'items#gpxp'
  get 'compare' => 'players#compare'
  get 'test' => 'players#test'
  get 'competitions' => 'players#competitions'
  get 'tracking' => 'players#tracking'
  get 'records' => 'players#records'
  get 'faqs' => 'players#faqs'
  get 'admin' => 'admin#index'
  put 'players.:id' => 'players#update_player'
  put 'update' => 'players#update_player'
  get 'players/:id/update' => 'players#update', as: :update_player
  get 'players/:id/check_acc_type' => 'players#check_acc_type', as: :check_acc_type
  post 'players#index' => 'players#refresh_250', as: :refresh_250
  post 'players#index' => 'players#refresh_players', as: :refresh_players
  post 'players#secretpage' => 'players#export_players', as: :export_players
  post 'players#names' => 'players#find_new', as: :find_new
  post 'items#update_prices' => 'items#update_prices', as: :update_prices
  post 'items#create_items' => 'items#create_items', as: :create_items

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
