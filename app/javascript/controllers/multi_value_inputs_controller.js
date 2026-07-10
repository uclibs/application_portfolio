import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { fieldName: String }

  add(event) {
    event.preventDefault()

    const fieldName = this.fieldNameValue
    if (!fieldName) return

    const index = this.nextIndex(fieldName)
    const row = document.createElement("div")
    row.className = "input-group mt-2"
    row.dataset.multivalueRow = "true"

    const input = document.createElement("input")
    input.type = "text"
    input.required = true
    input.name = `software_record[${fieldName}][]`
    input.id = `software_record_${fieldName}_${index}`
    input.className = "form-control"

    const removeBtn = document.createElement("button")
    removeBtn.type = "button"
    removeBtn.className = "btn btn-outline-danger js-remove-multivalue"
    removeBtn.textContent = "Delete"
    removeBtn.setAttribute("data-action", "click->multi-value-inputs#remove")

    row.appendChild(input)
    row.appendChild(removeBtn)
    this.element.appendChild(row)
    input.focus()
  }

  remove(event) {
    event.preventDefault()

    if (this.inputGroupCount() <= 1) return

    const row = event.target.closest(".input-group")
    if (row) row.remove()
  }

  inputGroupCount() {
    return this.element.querySelectorAll(".input-group").length
  }

  nextIndex(fieldName) {
    const prefix = `software_record_${fieldName}_`
    const inputs = this.inputsForField(fieldName)
    let max = 0

    inputs.forEach((input) => {
      const id = input.id
      if (id && id.startsWith(prefix)) {
        const n = parseInt(id.slice(prefix.length), 10)
        if (!Number.isNaN(n) && n > max) max = n
      }
    })

    return max + 1
  }

  inputsForField(fieldName) {
    const expectedName = `software_record[${fieldName}][]`
    return Array.prototype.filter.call(
      this.element.querySelectorAll("input"),
      (input) => input.name === expectedName
    )
  }
}
