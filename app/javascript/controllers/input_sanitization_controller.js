import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  sanitize(event) {
    const field = event.target
    if (!(field instanceof HTMLInputElement)) return

    const sanitized = field.value.replace(/[^a-zA-Z0-9 ]/g, "")
    if (sanitized !== field.value) field.value = sanitized
  }
}
