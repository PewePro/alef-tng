class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :check_token
  before_action :destroy_session
  skip_before_action :auth_user!

  def check_token
    #TODO: Zalogovat
    unless ApiAccessToken.verify(params[:token])
      render json: { status: "ERROR", error: "AUTH_ERROR" }
    end
  end

  def destroy_session
    request.session_options[:skip] = true
  end

  private
  def apply_filter(relation)
    start = params[:start] ? params[:start].to_i : 0

    begin
      after = Time.parse(params[:after])
    rescue ArgumentError, TypeError
      after = Time.now - 1.month
    end

    relation.offset(start).limit(1000).where('created_at > ?', after)
  end
end