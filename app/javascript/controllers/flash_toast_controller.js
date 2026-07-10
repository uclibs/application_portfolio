import { Controller } from "@hotwired/stimulus"
import bootstrap from "../bootstrap_setup"

export default class extends Controller {
  connect() {
    this.showToasts()
  }

  showToasts() {
    this.element.querySelectorAll(".flash-toast").forEach((element) => {
      if (element.classList.contains("show")) return

      bootstrap.Toast.getOrCreateInstance(element).show()
    })
  }
}
