Rails.application.routes.draw do

  get 'home/index'
  get 'home/lab_dashboard'
  get 'home/registration_dashboard'
  get 'home/nurse_dashboard'
  get 'home/waiting_room_dashboard'
  get '/lab_dashboard' => 'home#lab_dashboard'
  get '/registration_dashboard' => 'home#registration_dashboard'
  get '/nurse_dashboard' => 'home#nurse_dashboard'
  get '/waiting_room_dashboard' => 'home#waiting_room_dashboard'
  get 'home/ajax_lab_reception_list'
  get 'home/ajax_lab_dashboard_list'
  get 'home/ajax_nurse_dashboard_list'
  get 'home/ajax_waiting_room_dashboard'
  get 'home/ajax_lab_reception_stats'
  get '/time' => 'home#time'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'home#index'

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
