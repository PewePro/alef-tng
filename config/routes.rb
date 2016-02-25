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

  # Vrati dalsiu otazku podla odporucaca
  get 'w/:week_number/next' => 'questions#next'

  # Vypis otazky, napr. /PSI/3/16-validacia-a-verifikacia
  get 'w/:week_number/:id' => 'questions#show'
  get 'q/:id/image' => 'questions#show_image'

  # Loguje cas straveny na otazke
  post 'log_time' => 'questions#log_time'

  # Opravi otazku a vrati spravnu odpoved
  post 'w/:week_number/:id/evaluate_answers' => 'questions#evaluate'

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

  get 'admin/question_config/:course_id' => 'administrations#question_config', as: 'question_config'
  get 'admin/question_config/:question_id/edit_question_config' => 'administrations#edit_question_config', as: 'edit_question_config'
  post 'admin/question_config/:question_id/edit_question' => 'administrations#edit_question', as: 'edit_question'
  post 'admin/question_config/:question_id/edit_answers' => 'administrations#edit_answers', as: 'edit_answers'
  post 'admin/question_config/:question_id/delete_answer' => 'administrations#delete_answer', as: 'delete_answer'
  post 'admin/question_config/:question_id/add_answer' => 'administrations#add_answer', as: 'add_answer'

  get 'admin/question_concept_config/:course_id' => 'administrations#question_concept_config', as: 'question_concept_config'
  post 'admin/question_concept_config/:course_id/delete_question_concept' => 'administrations#delete_question_concept', as: 'delete_question_concept'
  post 'admin/question_concept_config/:course_id/add_question_concept' => 'administrations#add_question_concept', as: 'add_question_concept'

  get 'admin/questions/:id/feedbacks' => 'administrations#question_feedbacks', as: 'question_feedbacks'
  patch 'admin/feedbacks/:id/accept' => 'administrations#mark_feedback_accepted', as: 'mark_feedback_accepted'
  patch 'admin/feedbacks/:id/reject' => 'administrations#mark_feedback_rejected', as: 'mark_feedback_rejected'
  patch 'admin/feedbacks/:id/show' => 'administrations#mark_feedback_visible', as: 'mark_feedback_visible'
  patch 'admin/feedbacks/:id/hide' => 'administrations#mark_feedback_hidden', as: 'mark_feedback_hidden'

  get 'admin/courses/:id/questions/next_unresolved' => 'administrations#next_feedback_question', as: 'next_feedback_question'

  # Administracia.
  namespace :admin do

    resource :questions do
      get :index, :new
    end

  end


end
