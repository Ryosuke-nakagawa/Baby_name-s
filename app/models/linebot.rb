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
            @message.guide_to_initial_registration
            client.reply_message(event['replyToken'], @message.object) #返信用のデータ作成して送る
          end
          case @user.status
          when 'normal'
            if replied_message == '名前を新規登録'
              @message.send_message_in_characters
              client.reply_message(event['replyToken'], @message.object) #返信用のデータ作成して送る
              @user.name_registration!
            else
              @message.how_to_use
              client.reply_message(event['replyToken'], @message.object) #返信用のデータ作成して送る
            end
          when 'name_registration'
            new_first_name = FirstName.create(name: replied_message, group: @user.group)
            @user.update(editing_name: new_first_name)
            binding.pry
            fotune_telling = FotuneTelling.new(first_name: new_first_name.name, last_name: @user.group.last_name)
            binding.pry
            new_first_name.update(fotune_telling_url: fotune_telling.search_url)
            new_first_name.update(fotune_telling_rate: fotune_telling.rate)
            fotune_telling.image_save("public/fotune_telling_images/#{new_first_name.id}.jpg")
            new_first_name.update(fotune_telling_image: "#{new_first_name.id}.jpg")

            @message.send_message_in_reading              
            client.reply_message(event['replyToken'], @message.object) #返信用のデータ作成して送る
            @user.reading_registration!
          when 'reading_registration'
            @user.editing_name.update!(reading: replied_message)
            @message.send_rate_for_sound
            client.reply_message(event['replyToken'], @message.object) #返信用のデータ作成して送る
            @user.sound_rate_registration!
          when 'sound_rate_registration'
            Rate.create!(user: @user, first_name: @user.editing_name, sound_rate: replied_message.to_i)
            @message.send_rate_for_character                
            client.reply_message(event['replyToken'], @message.object) #返信用のデータ作成して送る
            @user.character_rate_registration!
          when 'character_rate_registration'
            rate = Rate.find_by(user: @user, first_name: @user.editing_name)
            rate.update!(character_rate: replied_message.to_i)
            @message.registration_is_complete
            
            client.reply_message(event['replyToken'], @message.object) #返信用のデータ作成して送る
            @user.update(editing_name_id: nil)
            @user.normal!
          end
        end
      end
    end
  end

  def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINEBOT_CHANNEL_SECRET"]
        config.channel_token = ENV["LINEBOT_CHANNEL_TOKEN"]
      }
  end
end