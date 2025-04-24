document.addEventListener("DOMContentLoaded", function () {
  var createdbyfield = document.getElementsByClassName('regex-createdby')[0];
  if (createdbyfield) {
    createdbyfield.onkeyup = function() {
      createdbyfield.value = createdbyfield.value.replace(/[^a-zA-Z0-9 ]/g, ''); // fixed regex too
    };
  }
});

