Rails.application.routes.draw do

  root to: redirect('w')

  devise_for :ldap_users, :local_users, skip: [:sessions]
  # the login controllers and views are shared for local and ldap users, use :local_user for routes
  devise_scope :local_user do
    get 'login',     to: 'users/sessions#new',     as: 'new_user_session'
    post 'login',    to: 'users/sessions#create',  as: 'user_session'
    delete 'logout', to: 'users/sessions#destroy', as: 'destroy_user_session'
  end

  # Vypis tyzdnov z daneho setupu, napr. /PSI
  get 'w' => 'weeks#list'

    # Vypis otazok z daneho tyzdna, napr. /PSI/3
  get 'w/:week_number' => 'weeks#show'

  # Vypis otazky, napr. /PSI/3/16-validacia-a-verifikacia
  get 'w/:week_number/:id' => 'questions#show'

  # Opravi otazku a vrati spravnu odpoved
  post 'w/:week_number/:id/evaluate_answers' => 'questions#evaluate'

  # Prepina zobrazovenie odpovedi ku otazkam
  post 'user/toggle-show-solutions' => 'users#toggle_show_solutions'

  post 'feedback' => 'users#send_feedback', as: 'feedback'

  # Administracia
  get 'admin' => 'administrations#index', as: 'administration'
  get 'admin/setup_config/:setup_id' => 'administrations#setup_config', as: 'setup_config'
  get 'admin/download_statistics/:setup_id' => 'administrations#download_statistics', as: 'download_statistics'
  post 'admin/setup_config/:setup_id/setup_attributes' => 'administrations#setup_config_attributes', as: 'setup_attributes'
  post 'admin/setup_config/:setup_id/setup_relations' => 'administrations#setup_config_relations', as: 'setup_relations'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
