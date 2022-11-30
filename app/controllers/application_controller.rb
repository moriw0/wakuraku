class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  check_authorization unless: :skip_checking_authorzation?

  def skip_checking_authorzation?
    devise_controller?
  end
end
