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
    unless user_signed_in? || devise_controller?
      session[:previous_url] = request.fullpath unless request.xhr? # do not store AJAX call
      redirect_to new_user_session_path
    end
    check_path
  end

  def find_room(id)
    rooms = current_user.rooms.eager_load(:learning_objects)
    lo = LearningObject.find(id)
    room =  rooms.reject{ |m| !(m.learning_objects.include?(lo)) }.first
    if room.present?
      params[:room_number] = room.id
      params[:week_number] = room.week_id
    end
  end

  def check_path
    if current_user.present?
      if current_user.has_rooms?
        if (params[:room_number].present? && params[:week_number].present? && params[:id].nil?)
          room = current_user.rooms.where("id = ?", params[:room_number])
          if room.count == 0
            available_room = current_user.rooms.where("week_id = ?", params[:week_number]).first
            params[:room_number] = available_room.id
          end
        elsif (params[:room_number].present? && params[:week_number].present? && params[:id].present?)
          id =  params[:id].partition('-').first.to_i
          r = current_user.rooms.eager_load(:learning_objects).where("rooms.id = ? AND rooms.week_id =? AND learning_objects.id = ?",params[:room_number],params[:week_number],id)
          if r.count == 0
            find_room(id)
          end
        elsif (params[:room_number].nil? && params[:week_number].present? && params[:id].present?)
          id =  params[:id].partition('-').first.to_i
          find_room(id)
        elsif (params[:room_number].nil? && params[:week_number].present? && params[:id].nil? && params[:lo_id].present?)
          find_room(params[:lo_id])
        end
      else
        if (params[:room_number].present? && params[:week_number].present? && params[:id].nil?)
          redirect_to :controller => 'weeks', :action => 'show'
        elsif (params[:room_number].present? && params[:week_number].present? && params[:id].present?)
          params[:room_number] = nil
        end
      end
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

  helper_method :user_signed_in?, :current_user, :user_session
end
