class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :check_admin, only: %i[new login]
  skip_before_action :login_required, only: %i[new login]
  before_action :set_admin_liffid, only: %i[new]
  layout 'layouts/application.html.slim'

  def new; end

  def login
    lineauthenticate = LineAuthenticateService.new(params[:idToken])
    lineauthenticate.call
    user = lineauthenticate.search_user
    session[:user_id] = user.id
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path, success: 'ログアウトしました'
  end
end
