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
      console.log(response.json); // => 200
      return response.json().then(response_uuid => {
        // JSONパースされたオブジェクトが渡される
        var uuid = response_uuid ;
        if (liff.isApiAvailable('shareTargetPicker')) {
          const url = `https://liff.line.me/1656693818-N2kw6Bvk?q=${uuid.id}`
          liff.shareTargetPicker([{
            type: "text",
            text: url
            },
          ],
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