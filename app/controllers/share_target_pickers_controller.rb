class ShareTargetPickersController < ApplicationController
  before_action :set_share_target_picker_liffid, only: %i[new]
  skip_before_action :login_required, only: %i[new login]

  def new; end

  def login
    line_authenticate_service = LineAuthenticateService.new(params[:idToken])
    user = User.find_by(line_id: line_authenticate_service.search_line_id)

    session[:user_id] = user.id
    uuid = { id: user.uuid }
    render json: uuid
  end
end
