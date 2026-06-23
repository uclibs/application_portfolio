document.addEventListener("turbo:load", function () {
  document.querySelectorAll(".regex-createdby").forEach(function (field) {
    field.addEventListener("keyup", function () {
      field.value = field.value.replace(/[^a-zA-Z0-9 ]/g, "")
    })
  })
})
