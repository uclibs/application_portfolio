import bootstrap from "./bootstrap_setup"

document.addEventListener("turbo:load", function () {
  document.querySelectorAll(".flash-toast").forEach(function (element) {
    bootstrap.Toast.getOrCreateInstance(element).show()
  })
})
