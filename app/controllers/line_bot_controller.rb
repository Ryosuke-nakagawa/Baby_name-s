class LineBotController < ApplicationController
  protect_from_forgery except: [:callback]

  def callback
    @linebot = Linebot.new(request)
    @linebot.respond_to_user

    head :ok
  end

end
