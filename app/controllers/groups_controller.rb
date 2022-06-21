class GroupsController < ApplicationController
  before_action :set_user, only: %i[new update]

  def new
    @group = @user.group
    @introduction = params[:introduction]
  end

  def update
    @group = @user.group
    ActiveRecord::Base.transaction do
      @group.update!(group_params)
      @user.update!(user_params)
    end
    # LINERICHメニューの切り替え
    uri = URI.parse("https://api.line.me/v2/bot/user/#{@user.line_id}/richmenu/#{ENV['RICH_MENU_ID_LOGGED_IN']}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new(uri.request_uri)
    req['Authorization'] = "Bearer {#{ENV['LINEBOT_CHANNEL_TOKEN']}}"
    res = http.request(req)
    redirect_to group_first_names_path(@group), success: t('defaults.message.updated', item: User.model_name.human)

    rescue => e
    flash.now[:danger] = t('defaults.message.not_updated', item: User.model_name.human)
    render :new
  end

  private

  def group_params
    params.require(:group).permit(:last_name,
                                  users_attributes: %i[id sound_rate_setting character_rate_setting
                                                       fortune_telling_rate_setting])
  end

  def user_params
    params[:group].require(:user).permit(:sound_rate_setting, :character_rate_setting, :fortune_telling_rate_setting)
  end

  def set_user
    @user = current_user
  end
end
