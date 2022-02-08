class Linebot
  require 'line/bot'
  require 'open-uri'
  include ActiveModel::Model

  attr_accessor :request

  def initialize(request)
    @request = request
    @message = Message.new
  end

  def respond_to_user
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE'] # リクエストのヘッダーの署名情報を取得
    unless client.validate_signature(body, signature) # 署名検証を行う https://developers.line.biz/ja/docs/messaging-api/receiving-messages/#verifying-signatures
      return head :bad_request
    end

    events = client.parse_events_from(body) # リクエストのbodyを抜き取る
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          @user = User.find_by(line_id: event['source']['userId'])
          replied_message = event.message['text']
          if @user.nil?
            @message.guide_to_initial_registration
            client.reply_message(event['replyToken'], @message.object)
          end
          case @user.status
          when 'normal'
            if replied_message == '名前を新規登録'
              if @user.group.last_name.nil?
                @message.registration_last_name
                client.reply_message(event['replyToken'], @message.object)
              else
                @message.send_message_in_characters
                client.reply_message(event['replyToken'], @message.object)
                @user.name_add!
              end
            else
              search_name = FirstName.find_by(group_id: @user.group.id, name: replied_message)
              if search_name.nil?
                @message.how_to_use
              else
                @message.fortune_telling(search_name)
              end
              client.reply_message(event['replyToken'], @message.object)
            end
          when 'name_add'
            new_first_name = FirstName.create(name: replied_message, group: @user.group)
            @user.update(editing_name: new_first_name)
            fortune_telling = FortuneTelling.new(first_name: new_first_name.name, last_name: @user.group.last_name)

            image_name = "img_#{Random.uuid}.jpg"
            fortune_telling.save_image_to_s3(image_name)

            new_first_name.update(fortune_telling_url: fortune_telling.search_url,
                                  fortune_telling_rate: fortune_telling.rate, fortune_telling_image: image_name)
            @message.send_message_in_reading
            client.reply_message(event['replyToken'], @message.object)
            @user.reading_add!
          when 'reading_add'
            @user.editing_name.update!(reading: replied_message)
            @message.send_rate_for_sound
            client.reply_message(event['replyToken'], @message.object)
            @user.sound_rate_add!
          when 'sound_rate_add'
            Rate.create!(user: @user, first_name: @user.editing_name, sound_rate: replied_message.to_i)
            @message.send_rate_for_character
            client.reply_message(event['replyToken'], @message.object)
            @user.character_rate_add!
          when 'character_rate_add'
            rate = Rate.find_by(user: @user, first_name: @user.editing_name)
            rate.update!(character_rate: replied_message.to_i)
            @message.registration_is_complete(@user.editing_name)
            client.reply_message(event['replyToken'], @message.object)

            group_users = @user.group.users
            group_users.each do |user|
              if @user != user
                if @user.name
                  text = "#{@user.name} さんが名前を登録しました。「名前一覧」から評価を行って下さい。"
                else
                  text = '同じグループメンバーが名前を登録しました。「名前一覧」から評価を行なって下さい。'
                end
                message = {
                  type: 'text',
                  text: text
                }
                response = client.push_message(user.line_id, message)
              end
            end

            @user.update(editing_name_id: nil)
            @user.normal!
          end
        end
      end
    end
  end

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINEBOT_CHANNEL_SECRET']
      config.channel_token = ENV['LINEBOT_CHANNEL_TOKEN']
    end
  end
end
