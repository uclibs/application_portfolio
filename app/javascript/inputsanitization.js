document.addEventListener("turbo:load", function () {
  const createdbyfield = document.getElementsByClassName("regex-createdby")[0];
  if (!createdbyfield) return;

  createdbyfield.onkeyup = function () {
    createdbyfield.value = createdbyfield.value.replace(/[^a-zA-Z0-9 ]/g, "");
  };
});
