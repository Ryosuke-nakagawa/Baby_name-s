document.addEventListener('DOMContentLoaded', () => {
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  liff.init({
    liffId: gon.liff_id
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
                "url": "https://enamae.net/result2/%E4%B8%AD%E5%B7%9D__%E5%87%8C%E8%BC%94.jpg",
                "size": "full",
                "aspectRatio": "6:5",
                "aspectMode": "cover",
                "action": {
                  "type": "uri",
                  "uri": "http://linecorp.com/"
                },
                "position": "relative"
              },
              "body": {
                "type": "box",
                "layout": "vertical",
                "contents": [
                  {
                    "type": "text",
                    "weight": "bold",
                    "size": "sm",
                    "text": "名前を評価・保存・シェアするアプリ",
                    "margin": "none",
                    "align": "center"
                  }
                ],
                "spacing": "none"
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
                "flex": 0
              }
            },
          }],
          ).catch(function (res) {
            //「シェアターゲットピッカー」が有効になっているが取得に失敗した場合 
            console.log('LINEのバージョンが古い可能性があります');
          });
        } else {
          //「シェアターゲットピッカー」が無効になっている場合
          console.log('「シェアターゲットピッカー」が無効になっています');
        }
      })
    })
  })
})