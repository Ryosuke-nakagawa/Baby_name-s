class Message

  attr_accessor :object

  def guide_to_initial_registration
    @object =
      {
        type: 'text',
        text: 'メニューバーの始めるからユーザー登録を行なってね'
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
        text: 'メニューバーから「新規登録」で名前候補を登録できるよ/登録された名前を漢字で送ると、姓名判断の結果を返すよ'
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

  def registration_is_complete
    @object =
      {
        type: 'text',
        text: '名前の登録が完了しました!'
      }
  end

  def fotune_telling(first_name)
    s3 = Aws::S3::Resource.new
    signer = Aws::S3::Presigner.new(client: s3.client)
    fotune_telling_image_url = signer.presigned_url(:get_object, bucket: ENV['AWS_BUCKET'], key: "/fotune_telling_images/#{first_name.fotune_telling_image}", expires_in: 300)

    @object = {
      'type': 'flex',
      'altText': '姓名判断の結果です。',
      'contents': {
        'type': 'bubble',
        'hero': {
          'type': 'image',
          'url': fotune_telling_image_url,
          'size': 'full',
          'aspectRatio': '10:9',
          'aspectMode': 'cover'
        },
        'footer': {
          'type': 'box',
          'layout': 'vertical',
          'spacing': 'sm',
          'contents': [
            {
              'type': 'button',
              'style': 'link',
              'height': 'sm',
              'action': {
                'type': 'uri',
                'label': '詳しく見る',
                'uri': first_name.fotune_telling_url
              }
            },
            {
              'type': 'spacer',
              'size': 'sm'
            }
          ],
          'flex': 0
        }
      }
    }
  end
end
