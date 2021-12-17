class Message

  attr_accessor :object

  def guide_to_initial_registration
    @object = {
      type: 'text',
      text: 'メニューバーの始めるからユーザー登録を行なってね'
      }
  end

  def send_message_in_characters
    @object = {
      type: 'text',
      text: '名前をメッセージで送ってください(漢字)'
      }
  end

  def how_to_use
    @object = {
      type: 'text',
      text: 'メニューバーから「新規登録」で名前候補を登録できるよ/登録された名前を漢字で送ると、姓名判断の結果を返すよ'
      }
  end

  def send_message_in_reading
    @object = {
      type: 'text',
      text: '名前の読みをメッセージで送ってください(ひらがな)'
    }
  end

  def send_rate_for_sound
    @object = {
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
  end

  def send_rate_for_character
    @object = {
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
  end

  def registration_is_complete
    @object = {
      type: 'text',
      text: "名前の登録が完了しました！"
      }
  end
                      
end