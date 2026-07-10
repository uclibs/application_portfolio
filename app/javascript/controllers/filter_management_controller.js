import { Controller } from "@hotwired/stimulus"
import { visit } from "@hotwired/turbo"

export default class extends Controller {
  static targets = ["vendorFilter", "softwareTypeFilter"]
  static values = { clearPath: String }

  togglePanels(event) {
    if (!this.hasVendorFilterTarget || !this.hasSoftwareTypeFilterTarget) return

    if (event.target.value === "vendor_records") {
      this.vendorFilterTarget.style.display = "block"
      this.softwareTypeFilterTarget.style.display = "none"
    } else {
      this.vendorFilterTarget.style.display = "none"
      this.softwareTypeFilterTarget.style.display = "block"
    }
  }

  submitForm() {
    this.element.requestSubmit()
  }

  clearAndRedirect(event) {
    event.preventDefault()

    if (this.hasVendorFilterTarget) this.vendorFilterTarget.style.display = "none"
    if (this.hasSoftwareTypeFilterTarget) this.softwareTypeFilterTarget.style.display = "none"
    visit(this.clearPathValue)
  }
}
