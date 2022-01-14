class LineBotController < ApplicationController
  protect_from_forgery except: [:callback]
  skip_before_action :login_required, only: [:callback]

  def callback
    @linebot = Linebot.new(request)
    @linebot.respond_to_user

    head :ok
  end
end
