window.addEventListener("load",function() {

  var selected = document.getElementById("select_box_js");
  selected.onchange = function() {
    window.location.href = selected.value;
    };
});
