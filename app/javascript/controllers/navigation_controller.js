import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidenav", "main"]

  connect() {
    this.resetMainLayout = this.resetMainLayout.bind(this)
    this.beforeCache = this.beforeCache.bind(this)
    document.addEventListener("turbo:load", this.resetMainLayout)
    document.addEventListener("turbo:before-cache", this.beforeCache)
  }

  disconnect() {
    document.removeEventListener("turbo:load", this.resetMainLayout)
    document.removeEventListener("turbo:before-cache", this.beforeCache)
  }

  open() {
    if (!this.hasSidenavTarget) return

    this.sidenavTarget.style.visibility = "visible"
    this.sidenavTarget.style.width = "250px"
  }

  close() {
    if (!this.hasSidenavTarget) return

    this.sidenavTarget.style.visibility = "hidden"
    this.sidenavTarget.style.width = "0"
  }

  resetMainLayout() {
    if (!this.hasMainTarget) return

    this.mainTarget.style.marginLeft = ""
  }

  beforeCache() {
    this.resetMainLayout()
    this.close()
  }
}
