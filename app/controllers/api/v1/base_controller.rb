class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :check_token
  before_action :destroy_session

  def check_token
    #TODO: Zalogovat
    unless ApiAccessToken.verify(params[:token])
      render json: { error: "AUTH_ERROR" }
    end
  end

  def destroy_session
    request.session_options[:skip] = true
  end
end