Rails.application.routes.draw do
  resources :players, :items, :clans
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
  get 'monster_ratio' => 'players#monster_ratio'
  get 'melee_order' => 'players#melee_order'
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
  get 'a_new_meta' => 'players#a_new_meta'
  get 'admin' => 'admin#index'
  put 'players.:id' => 'players#update_player'
  put 'update' => 'players#update_player'
  get 'players/:id/update' => 'players#update', as: :update_player
  get 'players/:id/check_acc_type' => 'players#check_acc_type', as: :check_acc_type
  get 'clans/index' => 'clans#index'
  get 'clans' => 'clans#index'
  get 'clans/:id/admin' => 'clans#admin', as: :clan_admin
  post 'clans/:id/add_player_to_clan' => 'clans#add_player_to_clan', as: :add_player_to_clan
  post 'clans/:id/add_many_players_to_clan' => 'clans#add_many_players_to_clan', as: :add_many_players_to_clan
  post 'clans/:id/remove_player_from_clan' => 'clans#remove_player_from_clan', as: :remove_player_from_clan
  post 'clans/:id/remove_many_players_from_clan' => 'clans#remove_many_players_from_clan', as: :remove_many_players_from_clan
  post 'clans/:id/update_clan_description' => 'clans#update_clan_description', as: :update_clan_description
  post 'clans/:id/update_clan_link1' => 'clans#update_clan_link1', as: :update_clan_link1
  post 'clans/:id/update_clan_link2' => 'clans#update_clan_link2', as: :update_clan_link2
  post 'players#index' => 'players#refresh_250', as: :refresh_250
  post 'players#index' => 'players#refresh_players', as: :refresh_players
  post 'players#secretpage' => 'players#export_players', as: :export_players
  post 'players#names' => 'players#find_new', as: :find_new
  post 'items#update_prices' => 'items#update_prices', as: :update_prices
  post 'items#create_items' => 'items#create_items', as: :create_items
  post 'admin#add_supporter' => 'admin#add_supporter', as: :add_supporter
  post 'admin#fix_spaces' => 'admin#fix_spaces', as: :fix_spaces
  post 'admin#change_name' => 'admin#change_name', as: :change_name

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
