class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :check_admin, only: %i[new login]
  skip_before_action :login_required, only: %i[new login]
  before_action :set_admin_liffid, only: %i[new]

  def new; end

  def login
    result = LineAuthenticateService.new(params[:idToken]).call
    user = User.find_by(line_id: result[:line_id])
    session[:user_id] = user.id
  end
end
