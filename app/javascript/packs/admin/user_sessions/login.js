document.addEventListener('DOMContentLoaded', () => {
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  
    liff.init({
      liffId: process.env.LIFF_ID_ADMIN
    })
    .then(() => {
      if (!liff.isLoggedIn()) {
        // 開発時、外部ブラウザからアクセスために利用
        liff.login();
      }
    })
    .then(() => {
      const idToken = liff.getIDToken();
      var body = `idToken=${idToken}`
      const request = new Request('/admin/login', {
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
          window.location = '/'
        }
        window.location = '/admin'
      })
      .catch(function(response) {
        console.log('Network error');
      })
    })
  })
  