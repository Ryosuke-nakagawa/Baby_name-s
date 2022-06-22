$('#js-account-share-button').on('click', function() {
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  liff.init({
    liffId: process.env.LIFF_ID_SHARE_TARGET_PICKER
  })
  .then(() => {
    if (!liff.isLoggedIn()) {
      // 開発時、外部ブラウザからアクセスために利用
      liff.login();
    }
  })
  .then(() => {
    const idToken = liff.getIDToken();
    const body = `idToken=${idToken}`
    const request = new Request('/share_target_pickers/login', {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
        'X-CSRF-Token': token
        },
        method: 'POST',
        body: body
        });
    fetch(request)
    .then(response => {
      return response.json().then(response_uuid => {
        // JSONパースされたオブジェクトが渡される
        var uuid = response_uuid ;
        if (liff.isApiAvailable('shareTargetPicker')) {
          const url = `https://liff.line.me/1656693818-N2kw6Bvk?q=${uuid.id}`
          liff.shareTargetPicker([{
            "type": "flex",
            "altText": "Baby names招待メッセージが届きました",
            "contents": {
              "type": "bubble",
              "hero": {
                "type": "image",
                "url": "https://www.baby-names-app.com/assets/card-cab16440c1e08d2685c36fef37bbfcb4121fd8fb849fc06efb9ad6c139aebb64.png",
                "size": "full",
                "aspectRatio": "2:1",
                "aspectMode": "cover",
                "position": "relative"
              },
              "footer": {
                "type": "box",
                "layout": "vertical",
                "spacing": "sm",
                "contents": [
                  {
                    "type": "button",
                    "style": "link",
                    "height": "sm",
                    "action": {
                      "type": "uri",
                      "label": "アカウントをシェアしてはじめる",
                      "uri": url
                    }
                  },
                  {
                    "type": "spacer",
                    "size": "sm"
                  }
                ],
              }
            },
          }],
          ).then((res) => {
            if (res) {
              // TargetPickerが送られた場合
              liff.closeWindow();
            } else {
              // TargetPickerを送らずに閉じた場合
              console.log('TargetPicker was closed!')
              liff.closeWindow();
            }
          })
          .catch(function (res) {
            alert('Failed to send')
          });
        } else {
          //「シェアターゲットピッカー」が無効になっている場合
          console.log('TargetPicker is disabled');
        }
      })
    })
  })
})