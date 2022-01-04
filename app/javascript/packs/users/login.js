document.addEventListener('DOMContentLoaded', () => {
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  liff.init({
    liffId: gon.liff_id
  })
  .then(() => {
    var param = getParam('q')
    const idToken = liff.getIDToken();
    if(!param){
      var body = `idToken=${idToken}`
    }else{
      var body = `idToken=${idToken}&uuid=${param}`
    }
    const request = new Request('https://baby-name-s.herokuapp.com/users', {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
        'X-CSRF-Token': token
        },
        method: 'POST',
        body: body
        });
    fetch(request)
    .then(() => {
      window.location = 'https://baby-name-s.herokuapp.com/groups/new'
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