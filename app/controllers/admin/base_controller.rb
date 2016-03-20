module Admin
  # Zdielany controller pre administraciu.
  class BaseController < ApplicationController

    before_filter :verify_admin

    private
    def verify_admin
      redirect_to(new_user_session_path) unless can?(:manage, :administration)
    end

  end
end