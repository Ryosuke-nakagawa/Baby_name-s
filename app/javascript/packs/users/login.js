document.addEventListener('DOMContentLoaded', () => {
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  liff.init({
    liffId: process.env.LIFF_ID_LOGIN
  })
  .then(() => {
    if (!liff.isLoggedIn()) {
      // 開発時、外部ブラウザからアクセスために利用
      liff.login();
    }
  })
  .then(() => {
    var param = getParam('q')
    const idToken = liff.getIDToken();
    if(!param){
      var body = `idToken=${idToken}`
      var introduction = false
    }else{
      var body = `idToken=${idToken}&uuid=${param}`
      var introduction = true
    }
    const request = new Request('/users', {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
        'X-CSRF-Token': token
        },
        method: 'POST',
        body: body
        });
    fetch(request)
    .then(response => {
      if (!response.ok) {
        console.error('Login failed');
      }
      if (introduction){
      window.location = '/groups/new?introduction=true'
      }else{
      window.location = '/groups/new?introduction=false'
      }
    })
    .catch(function(response) {
      console.log('Network error');
    })
  })
})

function getParam(name, url) {
  if (!url) url = window.location.href;
  name = name.replace(/[\[\]]/g, "\\$&");
  var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
      results = regex.exec(url);
  if (!results) return null;
  if (!results[2]) return '';
  return decodeURIComponent(results[2].replace(/\+/g, " "));
}