class LineBotController < ApplicationController
  protect_from_forgery except: [:callback]

  def callback
    body = request.body.read
  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINEBOT_CHANNEL_SECRET"]
      config.channel_token = ENV["LINEBOT_CHANNEL_TOKEN"]
    }
  end
end
