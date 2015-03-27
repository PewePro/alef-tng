class Users::SessionsController < Devise::SessionsController
  before_action :redirect_away, if: :user_signed_in?, only: [:new]

  def redirect_away
    redirect_to root_path
  end

  # GET /resource/sign_in
  def new
    # super
    self.resource = User.new(sign_in_params)
    # clean_up_passwords(resource)
    # respond_with(resource, serialize_options(resource))
  end

  # POST /resource/sign_in
  def create
    # super

    user_class = User.guess_type(params['local_user']['login'])
    request.params['ldap_user'] = request.params['local_user']

    self.resource = warden.authenticate! scope: user_class, recall: "#{controller_path}#new"
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(user_class, self.resource)
    respond_with self.resource, :location => after_sign_in_path_for(self.resource)
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end

end
