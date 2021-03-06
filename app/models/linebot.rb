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
          replied_message = event.message['text']
          @user = User.find_by(line_id: event['source']['userId'])
          @message.guide_to_initial_registration if @user.nil?
          case @user.status
          when 'normal'
            if replied_message == '名前を新規登録'
              if @user.group.last_name.nil?
                @message.registration_last_name
              else
                @message.send_message_in_characters
                @user.name_add!
              end
            else
              search_name = FirstName.find_by(group_id: @user.group.id, name: replied_message)
              search_name.nil? ? @message.how_to_use : @message.fortune_telling(search_name)
            end
          when 'name_add'
            @user.name_add(replied_message)
            @message.send_message_in_reading
          when 'reading_add'
            @user.reading_add(replied_message)
            @message.send_rate_for_sound
          when 'sound_rate_add'
            @user.sound_rate_add(replied_message)
            @message.send_rate_for_character
          when 'character_rate_add'
            @user.character_rate_add(replied_message)
            @message.registration_is_complete(@user.editing_name,
                                              Rate.find_by(user: @user, first_name: @user.editing_name))

            group_users = @user.group.users
            group_users.each do |user|
              next unless @user != user

              client.push_message(user.line_id, Message.new.notify_group_member(user.name))
            end
            @user.update(editing_name_id: nil, status: 'normal')
          end
        end
        client.reply_message(event['replyToken'], @message.object)
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
