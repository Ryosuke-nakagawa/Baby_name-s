class LineBotController < ApplicationController
  protect_from_forgery except: [:callback]

  require 'open-uri'

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
            new_first_name = FirstName.create(name: replied_message, group: @user.group)
            @user.update(editing_name: new_first_name)

            full_name = "#{@user.group.last_name}__#{new_first_name.name}"
            search_param = URI.encode_www_form_component(full_name)
            #姓名判断結果(html)を取得
            new_first_name.update(fotune_telling_url: "https://enamae.net/m/#{search_param}#result")
            html = URI.open("https://enamae.net/m/#{search_param}#result").read
            doc = Nokogiri::HTML.parse(html)
            #結果を元に(評価)を判断
            daikiti = doc.css(".daikiti").count
            kiti =doc.css(".kiti").count
            kikkyou= doc.css(".kikkyou").count
            kyou= doc.css(".kyou").count
            tokusyu= doc.css(".tokusyu").count
            fotune_telling_result = ( daikiti * 5 + kiti * 4 + kikkyou * 3 + tokusyu * 3 + kyou * 2 ) / 6
            new_first_name.update(fotune_telling_rate: fotune_telling_result)

            #姓名判断の結果(画像)を取得
            image_url = "https://enamae.net/result2/#{search_param}.jpg"
            file = "public/fotune_telling_images/#{new_first_name.id}.jpg"
            new_first_name.update(fotune_telling_image: "#{new_first_name.id}.jpg")
            File.open(file, 'wb') do |img|
              img.write(URI.open(image_url).read)
            end

            message = {
              type: 'text',
              text: '名前の読みをメッセージで送ってください(ひらがな)'
              }
            client.reply_message(event['replyToken'], message) #返信用のデータ作成して送る
            @user.reading_registration!
          when 'reading_registration'
            @user.editing_name.update!(reading: replied_message)

            message = {
              type: 'text',
              text: "名前が登録されました！この名前の「音の響き」に評価をつけるなら5段階でどれですか?",
              quickReply: {
                items: [
                  {
                    type: 'action',
                    action: {
                      type: 'message',
                      label: '1',
                      text: '1'
                      }
                  },
                  {
                    type: 'action',
                    action: {
                      type: 'message',
                      label: '2',
                      text: '2'
                    }
                  },
                  {
                    type: 'action',
                    action: {
                      type: 'message',
                      label: '3',
                      text: '3'
                    }
                  },
                  {
                    type: 'action',
                    action: {
                      type: 'message',
                      label: '4',
                      text: '4'
                    }
                  },
                  {
                    type: 'action',
                    action: {
                      type: 'message',
                      label: '5',
                      text: '5'
                    }
                  }
                ]
              }
            }
            client.reply_message(event['replyToken'], message) #返信用のデータ作成して送る
            @user.update(editing_name_id: nil)
            @user.sound_rate_registration!
          when 'sound_rate_registration'
            message = {
              type: 'text',
              text: "この名前の「漢字」に評価をつけるなら5段階でどれですか?",
              quickReply: {
                items: [
                  {
                    type: 'action',
                    action: {
                      type: 'message',
                      label: '1',
                      text: '1'
                      }
                  },
                  {
                    type: 'action',
                    action: {
                      type: 'message',
                      label: '2',
                      text: '2'
                    }
                  },
                  {
                    type: 'action',
                    action: {
                      type: 'message',
                      label: '3',
                      text: '3'
                    }
                  },
                  {
                    type: 'action',
                    action: {
                      type: 'message',
                      label: '4',
                      text: '4'
                    }
                  },
                  {
                    type: 'action',
                    action: {
                      type: 'message',
                      label: '5',
                      text: '5'
                    }
                  }
                ]
              }
            }
            client.reply_message(event['replyToken'], message) #返信用のデータ作成して送る
            @user.character_rate_registration!
          when 'character_rate_registration'
            message = {
              type: 'text',
              text: "名前の登録が完了しました！"
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
