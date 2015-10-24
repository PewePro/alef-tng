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

  #Vypis miestnosti z daneho tyzdna
  get 'w/:week_number/:room_number' => 'rooms#show'

  # Vypis otazky, napr. /PSI/3/16-validacia-a-verifikacia
  get 'w/:week_number/:room_number/:id' => 'questions#show'
  get 'w/:week_number/:room_number/:id/image' => 'questions#show_image'

  # Loguje cas straveny na otazke
  post 'log_time' => 'questions#log_time'

  # Opravi otazku a vrati spravnu odpoved
  post 'w/:week_number/:id/evaluate_answers' => 'questions#evaluate'

  # Prepina zobrazovenie odpovedi ku otazkam
  post 'user/toggle-show-solutions' => 'users#toggle_show_solutions'

  post 'feedback' => 'users#send_feedback', as: 'feedback'



  # Administracia
  get 'admin' => 'administrations#index', as: 'administration'

  get 'admin/setup_config/:setup_id' => 'administrations#setup_config', as: 'setup_config'
  get 'admin/setup_config/:setup_id/download_statistics' => 'administrations#download_statistics', as: 'download_statistics'
  post 'admin/setup_config/:setup_id/setup_attributes' => 'administrations#setup_config_attributes', as: 'setup_attributes'
  post 'admin/setup_config/:setup_id/setup_relations' => 'administrations#setup_config_relations', as: 'setup_relations'

  get 'admin/question_concept_config/:course_id' => 'administrations#question_concept_config', as: 'question_concept_config'
  post 'admin/question_concept_config/:course_id/delete_question_concept' => 'administrations#delete_question_concept', as: 'delete_question_concept'
  post 'admin/question_concept_config/:course_id/add_question_concept' => 'administrations#add_question_concept', as: 'add_question_concept'


end
