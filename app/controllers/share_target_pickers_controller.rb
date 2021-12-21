class ShareTargetPickersController < ApplicationController
  before_action :set_share_target_picker_liffid, only: [:new]
  skip_before_action :login_required, only: [:new, :login]

  def new
  end

  def login
    idToken = params[:idToken]
    channelId = ENV['LIFF_CHANNEL_ID']
    res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'),{'id_token'=>idToken, 'client_id'=>channelId})
    res_line_id = JSON.parse(res.body)["sub"]
    user = User.find_by(line_id: res_line_id)

    session[:user_id] = user.id
    uuid = { id: user.uuid }
    render json: uuid
  end
end
