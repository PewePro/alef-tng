class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Exceptions

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :auth_user!, except: [:ping]


  def auth_user!
    unless user_signed_in? || devise_controller? || request.env['PATH_INFO'].starts_with?('/api/')
      session[:previous_url] = request.fullpath unless request.xhr? # do not store AJAX calls
      redirect_to new_user_session_path
    end
  end

  def ping
    render html: 'PING_OK'
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  protected

  def user_signed_in?
    local_user_signed_in? || ldap_user_signed_in?
  end

  def current_user
    current_local_user || current_ldap_user
  end

  def user_session
    local_user_session || ldap_user_session
  end

  # Pomocna metoda, vyziada potrebne parametre v URL adrese.
  #
  # @param required_params [Array] zoznam pozadovanych parametrov (ako String) v adrese poziadavky
  # @raise [MissingArgumentError] ak aspon jeden parameter chyba
  def require_params(*required_params)

    missing = []
    required_params.each do |param|
      missing << param unless params[param].present?
    end

    raise MissingArgumentError.new("Missing parametres: ".missing.join(', ')) if missing.any?

  end

  helper_method :user_signed_in?, :current_user, :user_session
end
