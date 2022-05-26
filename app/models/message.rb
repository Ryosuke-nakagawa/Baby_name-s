class Message
  attr_accessor :object

  def guide_to_initial_registration
    @object =
      {
        type: 'text',
        text: 'メニューバーの「START」からユーザー登録を行なってね'
      }
  end

  def registration_last_name
    @object =
      {
        type: 'text',
        text: 'メニューの「ユーザー設定」から姓を登録してね'
      }
  end

  def send_message_in_characters
    @object =
      {
        type: 'text',
        text: '名前をメッセージで送ってください(漢字)'
      }
  end

  def how_to_use
    @object =
      {
        type: 'text',
        text: 'メニューバーから「新規登録」で名前候補を登録できるよ / 登録された名前を漢字で送ると、姓名判断の結果を返すよ'
      }
  end

  def send_message_in_reading
    @object =
      {
        type: 'text',
        text: '名前の読みをメッセージで送ってください(ひらがな)'
      }
  end

  def send_rate_for_sound
    @object = {
      type: 'text',
      text: '名前が登録されました!この名前の「音の響き」に評価をつけるなら5段階でどれですか?',
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
  end

  def send_rate_for_character
    @object = {
      type: 'text',
      text: 'この名前の「漢字」に評価をつけるなら5段階でどれですか?',
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
  end

  def registration_is_complete(first_name, _rate)
    rate_column = make_rate_column(first_name.fortune_telling_rate)
    @object = {
      type: 'flex',
      altText: 'お名前の登録が完了しました!',
      contents:
        {
          type: 'bubble',
          header: {
            type: 'box',
            layout: 'vertical',
            contents: [
              {
                type: 'text',
                text: 'お名前の登録が完了しました!',
                weight: 'regular',
                size: 'md'
              }
            ]
          },
          body: {
            type: 'box',
            layout: 'vertical',
            contents: [
              {
                type: 'text',
                text: first_name.decorate.full_name,
                weight: 'bold',
                size: 'xl'
              },
              {
                type: 'box',
                layout: 'vertical',
                margin: 'lg',
                spacing: 'sm',
                contents: [
                  {
                    type: 'box',
                    layout: 'baseline',
                    spacing: 'sm',
                    contents: [
                      {
                        type: 'text',
                        text: '姓名判断の結果は...',
                        wrap: true,
                        color: '#666666',
                        size: 'sm',
                        flex: 5
                      }
                    ]
                  }
                ]
              },
              {
                type: 'box',
                layout: 'baseline',
                margin: 'md',
                contents: rate_column
              }
            ]
          },
          footer: {
            type: 'box',
            layout: 'vertical',
            spacing: 'sm',
            contents: [
              {
                type: 'button',
                style: 'link',
                height: 'sm',
                action: {
                  type: 'uri',
                  label: '姓名判断の結果を詳しく見てみる',
                  uri: first_name.fortune_telling_url
                }
              },
              {
                type: 'button',
                style: 'link',
                height: 'sm',
                action: {
                  type: 'uri',
                  label: '名前一覧ページを確認する',
                  uri: 'https://liff.line.me/1656693818-8gP0Y6jP'
                }
              },
              {
                type: 'box',
                layout: 'vertical',
                contents: [],
                margin: 'sm'
              }
            ],
            flex: 0
          }
        }
    }
  end

  def fortune_telling(first_name)
    rate_column = make_rate_column(first_name.fortune_telling_rate)
    @object = {
      type: 'flex',
      altText: 'お名前が登録されています。',
      contents:
        {
          type: 'bubble',
          body: {
            type: 'box',
            layout: 'vertical',
            contents: [
              {
                type: 'text',
                text: first_name.decorate.full_name,
                weight: 'bold',
                size: 'xl'
              },
              {
                type: 'box',
                layout: 'vertical',
                margin: 'lg',
                spacing: 'sm',
                contents: [
                  {
                    type: 'box',
                    layout: 'baseline',
                    spacing: 'sm',
                    contents: [
                      {
                        type: 'text',
                        text: '姓名判断の結果は...',
                        wrap: true,
                        color: '#666666',
                        size: 'sm',
                        flex: 5
                      }
                    ]
                  }
                ]
              },
              {
                type: 'box',
                layout: 'baseline',
                margin: 'md',
                contents: rate_column
              }
            ]
          },
          footer: {
            type: 'box',
            layout: 'vertical',
            spacing: 'sm',
            contents: [
              {
                type: 'button',
                style: 'link',
                height: 'sm',
                action: {
                  type: 'uri',
                  label: '姓名判断の結果を詳しく見てみる',
                  uri: first_name.fortune_telling_url
                }
              },
              {
                type: 'button',
                style: 'link',
                height: 'sm',
                action: {
                  type: 'uri',
                  label: '名前一覧ページを確認する',
                  uri: 'https://liff.line.me/1656693818-8gP0Y6jP'
                }
              },
              {
                type: 'box',
                layout: 'vertical',
                contents: [],
                margin: 'sm'
              }
            ],
            flex: 0
          }
        }
    }
  end

  def make_rate_column(rate)
    str = []
    star_on_icon = { type: 'icon', size: 'lg',
                     url: 'https://www.baby-names-app.com/assets/star-on-95de31432e40ba75764bce2ab31dcd90df5815ad58d64e4cc8a2c9399f78f572.png' }
    star_off_icon = { type: 'icon', size: 'lg',
                      url: 'https://www.baby-names-app.com/assets/star-off-545623b9692f7e1a13280ea370b31bd9dd324abb4181f98497134795d012d472.png' }

    rate.times do
      str << star_on_icon
    end
    if rate != 5
      (5 - rate).times do
        str << star_off_icon
      end
    end

    str << { type: 'text', text: rate.to_s, size: 'lg', color: '#999999', margin: 'md', flex: 0 }

    str
  end

  def notify_group_member(user_name)
    text = user_name ? "#{user_name}さんが名前を登録しました。「名前一覧」から評価を行って下さい。" : '同じグループメンバーが名前を登録しました。「名前一覧」から評価を行なって下さい。'

    @object = {
      type: 'text',
      text: text
    }
  end
end
