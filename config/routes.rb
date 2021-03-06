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
  get 'w' => 'weeks#list', as: 'index_week'

    # Vypis otazok z daneho tyzdna, napr. /PSI/3
  get 'w/:week_number' => 'weeks#show'

  # Vrati dalsiu otazku podla odporucaca
  get 'w/:week_number/:room_number/:lo_id/next' => 'questions#next'
  get 'w/:week_number/next' => 'questions#next'

  #Vypis miestnosti z daneho tyzdna
  get 'w/tests/:week_number/:room_number' => 'rooms#show'

  # Vypis otazky, napr. /PSI/3/16-validacia-a-verifikacia
  get 'w/tests/:week_number/:room_number/:id' => 'questions#show'
  get 'w/tests/:week_number/:room_number/:id/image' => 'questions#show_image'
  get 'w/:week_number/:id' => 'questions#show', as: 'show_learning_object'

  # Docasne takto, postupne sa prejde na namespace aj pre vzdelavacie objekty.
  get 'learning_objects/:id/image' => 'questions#show_image', as: 'show_single_image'

  # Loguje cas straveny na otazke
  post 'log_time' => 'questions#log_time'

  # Opravi otazku a vrati spravnu odpoved
  post 'w/tests/:week_number/:room_number/:id/evaluate_answers' => 'questions#evaluate'
  post 'w/:week_number/:id/evaluate_answers' => 'questions#evaluate'

  # Vyhodnoti pracu v danej miestnosti
  post 'w/tests/:week_number/:room_number/eval' => 'rooms#eval'
  get 'w/tests/:week_number/:room_number/:id/eval' => 'rooms#eval'

  # Vytvori novu miestnost
  get 'w/tests/:week_number/:room_number/:id/new' => 'rooms#new'

  # Prepina zobrazovenie odpovedi ku otazkam
  post 'user/toggle-show-solutions' => 'users#toggle_show_solutions'

  post 'feedback' => 'users#send_feedback', as: 'feedback'

  get 'ping' => 'application#ping'

  # Markdown
  post 'markdown/preview' => 'markdown/preview'

  # Administracia
  get 'admin' => 'administrations#index', as: 'administration'

  get 'admin/setup_config/:setup_id' => 'administrations#setup_config', as: 'setup_config'
  get 'admin/setup_config/:setup_id/download_statistics' => 'administrations#download_statistics', as: 'download_statistics'
  post 'admin/setup_config/:setup_id/setup_attributes' => 'administrations#setup_config_attributes', as: 'setup_attributes'
  post 'admin/setup_config/:setup_id/setup_relations' => 'administrations#setup_config_relations', as: 'setup_relations'

  get 'admin/question_concept_config/:course_id' => 'administrations#question_concept_config', as: 'question_concept_config'
  post 'admin/question_concept_config/:course_id/delete_question_concept' => 'administrations#delete_question_concept', as: 'delete_question_concept'
  post 'admin/question_concept_config/:course_id/add_question_concept' => 'administrations#add_question_concept', as: 'add_question_concept'

  get 'admin/questions/:id/feedbacks' => 'administrations#question_feedbacks', as: 'question_feedbacks'
  patch 'admin/feedbacks/:id/accept' => 'administrations#mark_feedback_accepted', as: 'mark_feedback_accepted'
  patch 'admin/feedbacks/:id/reject' => 'administrations#mark_feedback_rejected', as: 'mark_feedback_rejected'
  patch 'admin/feedbacks/:id/show' => 'administrations#mark_feedback_visible', as: 'mark_feedback_visible'
  patch 'admin/feedbacks/:id/hide' => 'administrations#mark_feedback_hidden', as: 'mark_feedback_hidden'
  patch 'admin/feedbacks/:id/anonymize' => 'administrations#mark_feedback_anonymized', as: 'mark_feedback_anonymized'

  get 'admin/courses/:id/questions/next_unresolved' => 'administrations#next_feedback_question', as: 'next_feedback_question'

  # Administracia.
  namespace :admin do

    resources :learning_objects do
      get :index, :new, :edit
      patch :update, :restore
      post :create
      delete :destroy

      resources :answers do
        patch :update, on: :collection
        post :create
        delete :delete
      end

      resources :feedbacks do
        post :create
      end

    end

    resources :concepts do
      get :index, :learning_objects
      post :create
      patch :update
      delete :destroy
      delete :delete_learning_object, on: :collection
    end

    resources :apis do
      get :index
      post :create
    end

  end

  # API
  namespace :api do
    namespace :v1 do
      resources :concepts, only: [:index]
      resources :concept_weeks, only: [:index]
      resources :concepts_learning_objects, only: [:index]
      resources :courses, only: [:index]
      resources :feedbacks, only: [:index]
      resources :learning_objects, only: [:index]
      resources :setups, only: [:index]
      resources :user_to_lo_relations, only: [:index]
      resources :users, only: [:index]
      resources :weeks, only: [:index]

      post 'auth' => 'sessions#create'
      get 'check' => 'sessions#check'
    end
  end

end
