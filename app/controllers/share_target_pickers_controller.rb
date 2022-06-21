class ShareTargetPickersController < ApplicationController
  before_action :set_share_target_picker_liffid, only: %i[new]
  skip_before_action :login_required, only: %i[new login]

  def new; end

  def login
    lineauthenticate = LineAuthenticateService.new(params[:idToken])
    lineauthenticate.call
    user = lineauthenticate.search_user

    session[:user_id] = user.id
    uuid = { id: user.uuid }
    render json: uuid
  end
end
