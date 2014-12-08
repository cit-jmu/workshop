Rails.application.routes.draw do
  devise_for :users
  authenticated :user do
    devise_scope :user do
      root to: 'users#show', as: 'dashboard'
      get 'profile', as: 'profile', to: 'users#edit'
    end
  end

  resources :courses do
    resources :sections do
      member do
        post 'enroll'
        post 'enroll_user'
        delete 'drop'
        delete 'drop_user'
        patch 'mark_completed'
      end
    end
  end

  resources :users

  get 'catalog/index'
  get 'calendar', to: 'calendar#index'

  # routes for feed integration to CIT website
  get 'feed', to: 'feed#index'
  get 'feed/upcoming'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'catalog#index'

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
