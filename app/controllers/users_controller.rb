class UsersController < ApplicationController
  include Searchables::Search

  default_tab :all, only: :index
  default_tab :results, only: :search
  default_tab :profile, only: :show
  default_tab :followers, only: :followings

  before_action :authenticate_user!

  def index
    @users = case params[:tab].to_sym
             when :recent then User.recent.order(created_at: :desc)
             else User.order(:nick)
             end

    @users = @users.page(params[:page]).per(60)
  end

  def show
    @user = User.by(nick: params[:nick])

    @questions  = @user.questions.where(anonymous: false).order(created_at: :desc)
    @anonymous  = @user.questions.where(anonymous: true).order(created_at: :desc)
    @answers    = @user.answers.order(created_at: :desc)
    @favorites  = @user.favorites.order(created_at: :desc)
    @activities = @user.activities_seen_by(current_user).order(created_at: :desc)

    @questions  = @questions.page(tab_page :questions).per(10)
    @anonymous  = @anonymous.page(tab_page :anonymous).per(10)
    @answers    = @answers.page(tab_page :answers).per(10)
    @favorites  = @favorites.page(tab_page :favorites).per(10)
    @activities = @activities.page(tab_page :activities).per(20)

    @question = Question.unanswered.random.first || Question.random.first
  end

  def update
    authorize! :edit, current_user

    if current_user.update_attributes(user_params)
      form_message :notice, t('user.update.success'), key: params[:tab]
    else
      form_error_messages_for current_user, key: params[:tab]
    end

    redirect_to edit_user_registration_path(tab: params[:tab])
  end

end