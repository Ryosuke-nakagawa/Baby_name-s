document.addEventListener('DOMContentLoaded', () => {

  let introduction = getParam('introduction')
  if (introduction === 'true'){
    $('#js-introduction-modal-1').show();
  }

  $('.js-introduction-modal-open').on('click',function(){
    var target = $(this).data('target');
    $('.modal').hide();
    $('#js-introduction-modal-' + target).show();
    return false;
  });
  

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