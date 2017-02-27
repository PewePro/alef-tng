module Admin
  # Umoznuje spravovat API.
  class ApisController < BaseController

    # Vykresli zoznam vsetkych pouzivatelov s API klucom.
    def index
      @users = User.where.not(private_key: nil)
    end

    # Vygeneruje API privatny kluc pre pouzivatela.
    def create
      @private_key = User.where(login: params[:api][:login]).first.generate_private_key!
    end

  end
end