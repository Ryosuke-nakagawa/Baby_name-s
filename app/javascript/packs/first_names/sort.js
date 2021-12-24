window.onload = function(){

  var selected = document.getElementById("sort_js");
  selected.onchange = function() {
    window.location.href = selected.value;
    };
};
