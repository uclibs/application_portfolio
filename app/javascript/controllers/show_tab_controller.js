import { Controller } from "@hotwired/stimulus"
import bootstrap from "../bootstrap_setup"

export default class extends Controller {
  connect() {
    requestAnimationFrame(() => this.showHashTab())
  }

  showHashTab() {
    const hash = window.location.hash
    if (!hash) return

    const tabTrigger = Array.from(this.element.querySelectorAll('a[href^="#"]')).find(
      (link) => link.getAttribute("href") === hash
    )
    if (!tabTrigger) return

    bootstrap.Tab.getOrCreateInstance(tabTrigger).show()
  }
}
