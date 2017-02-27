class Api::V1::SessionsController < ApplicationController
  protect_from_forgery with: :null_session

  # Vytvori novu autentifikaciu.
  def create

    user = User.where(login: params[:login]).first
    if BCrypt::Password.new(user.private_key).is_password?(params[:key])
      token = user.generate_access_token!
      render json: { token: token.token, expires_at: token.expires_at }
    else
      render json: { error: "AUTH_ERROR" }
    end

  end

  # Overi, ci je pouzivatel autentifikovany a kedy token exspiruje.
  def check
    token = ApiAccessToken.verify(params[:token])
    if token
      render json: { status: "OK", expires_at: token.expires_at }
    else
      render json: { status: "ERROR", error: "TOKEN_EXPIRED" }
    end
  end

end