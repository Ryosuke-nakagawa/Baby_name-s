class LineBotController < ApplicationController
  protect_from_forgery except: [:callback]

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE'] #リクエストのヘッダーの署名情報を取得
    unless client.validate_signature(body, signature) #署名検証を行う https://developers.line.biz/ja/docs/messaging-api/receiving-messages/#verifying-signatures
      return head :bad_request
    end
    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
            }
          client.reply_message(event['replyToken'], message)
        end
      end
    end
    head :ok
  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINEBOT_CHANNEL_SECRET"]
      config.channel_token = ENV["LINEBOT_CHANNEL_TOKEN"]
    }
  end
end
