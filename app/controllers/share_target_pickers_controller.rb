class ShareTargetPickersController < ApplicationController
  before_action :set_share_target_picker_liffid, only: %i[new]
  skip_before_action :login_required, only: %i[new login]

  def new; end

  def login
    id_token = params[:idToken]
    channel_id = ENV['LIFF_CHANNEL_ID']
    res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'), { 'id_token' => id_token, 'client_id' => channel_id })
    res_line_id = JSON.parse(res.body)['sub']
    user = User.find_by(line_id: res_line_id)

    session[:user_id] = user.id
    uuid = { id: user.uuid }
    render json: uuid
  end
end
