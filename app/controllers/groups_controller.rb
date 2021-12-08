class GroupsController < ApplicationController
  def new
    @user = User.find(session[:user_id])
    @group = @user.group
  end

  def update
    @user = User.find(session[:user_id])
    @group = Group.find(params[:id])
    if @group.update(group_params) && @user.update(user_params)
      uri = URI.parse("https://api.line.me/v2/bot/user/#{@user.line_id}/richmenu/#{ENV['RICH_MENU_ID_LOGGED_IN']}")
      http = Net::HTTP.new(uri.host, uri.port)

      http.use_ssl = true #なかったらエラー発生
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE #なくてもエラーは出なかった

      req = Net::HTTP::Post.new(uri.request_uri)
      req["Authorization"] = "Bearer {#{ENV['LINEBOT_CHANNEL_TOKEN']}}"
      res = http.request(req)

      binding.pry
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def group_params
    params.require(:group).permit(:last_name, users_attributes: [:id, :sound_rate_setting, :character_rate_setting, :fotune_telling_rate_setting])
  end
  def user_params
    params[:group].require(:user).permit(:sound_rate_setting, :character_rate_setting, :fotune_telling_rate_setting)
  end
end
