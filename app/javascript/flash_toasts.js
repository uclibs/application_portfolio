import bootstrap from "./bootstrap_setup"

document.addEventListener("turbo:load", () => {
  document.querySelectorAll(".flash-toast").forEach((element) => {
    if (element.classList.contains("show")) return

    bootstrap.Toast.getOrCreateInstance(element).show()
  })
})
