class LineBotController < ApplicationController
  protect_from_forgery except: [:callback]

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE'] #リクエストのヘッダーの署名情報を取得
    unless client.validate_signature(body, signature) #署名検証を行う https://developers.line.biz/ja/docs/messaging-api/receiving-messages/#verifying-signatures
      return head :bad_request
    end
    events = client.parse_events_from(body) #リクエストのbodyを抜き取る
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          @user = User.find_by(line_id: event['source']['userId'])
          replied_message = event.message['text']
          if @user.nil?
            message = {
              type: 'text',
              text: 'メニューバーの始めるからユーザー登録を行なってね'
              }
            client.reply_message(event['replyToken'], message) #返信用のデータ作成して送る
          end
          case @user.status
          when 'normal'
            if replied_message == '名前を新規登録'
              message = {
                type: 'text',
                text: '名前をメッセージで送ってください(漢字)'
                }
              client.reply_message(event['replyToken'], message) #返信用のデータ作成して送る
              @user.name_registration!
            else
              message = {
                type: 'text',
                text: 'メニューバーから「新規登録」で名前候補を登録できるよ/登録された名前を漢字で送ると、姓名判断の結果を返すよ'
                }
              client.reply_message(event['replyToken'], message) #返信用のデータ作成して送る
            end
          when 'name_registration'
            new_name = FirstName.create(name: replied_message, group: @user.group)
            @user.update(editing_name: new_name)
            message = {
              type: 'text',
              text: '名前の読みをメッセージで送ってください(ひらがな)'
              }
            client.reply_message(event['replyToken'], message) #返信用のデータ作成して送る
            @user.reading_registration!
          when 'reading_registration'
            @user.editing_name.update!(reading: replied_message)
            @user.update(editing_name_id: nil)
            message = {
              type: 'text',
              text: '名前が登録されました！評価ページはこちら'
              }
            client.reply_message(event['replyToken'], message) #返信用のデータ作成して送る
            @user.normal!
          end
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
