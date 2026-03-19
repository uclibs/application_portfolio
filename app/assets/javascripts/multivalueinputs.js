// app/assets/javascripts/multivalueinputs.js
// Multi-value input add/remove (Bootstrap 5)
// Works with markup from _multi_value_field.html.erb:
// - container id:  multiple_<fieldName>
// - add button:    .js-add-multivalue  data-field-name="<fieldName>"
// - remove button: .js-remove-multivalue

(() => {
  "use strict";

  // Guard against double-including this asset (prevents duplicate event handlers)
  if (window.__multivalueinputs_bound) return;
  window.__multivalueinputs_bound = true;

  const containerFor = (name) => document.getElementById(`multiple_${name}`);

  const nextIndex = (container, name) =>
    container.querySelectorAll(`input[name="software_record[${name}][]"]`).length + 1;

  function add(name, value = "") {
    const container = containerFor(name);
    if (!container) return;

    const index = nextIndex(container, name);

    const row = document.createElement("div");
    row.className = "input-group mt-2";
    row.dataset.multivalueRow = "true";

    const input = document.createElement("input");
    input.type = "text";
    input.required = true; // keep existing behavior
    input.name = `software_record[${name}][]`;
    input.id = `software_record_${name}_${index}`;
    input.className = "form-control";
    input.value = value;

    const removeBtn = document.createElement("button");
    removeBtn.type = "button";
    removeBtn.className = "btn btn-outline-danger js-remove-multivalue";
    removeBtn.textContent = "Delete";

    row.appendChild(input);
    row.appendChild(removeBtn);
    container.appendChild(row);

    input.focus();
  }

  // Delegated click handling: no per-page binding, no button IDs needed.
  document.addEventListener("click", (e) => {
    const addBtn = e.target.closest(".js-add-multivalue");
    if (addBtn) {
      e.preventDefault();
      add(addBtn.dataset.fieldName, "");
      return;
    }

    const removeBtn = e.target.closest(".js-remove-multivalue");
    if (removeBtn) {
      e.preventDefault();
      removeBtn.closest(".input-group")?.remove();
    }
  });

  // Optional: export add() for compatibility if other code still calls it.
  window.addMultiValueInput = add;
})();