// Multi-value input add/remove (Bootstrap 5)
// Works with markup from _form_multi_*.html.erb and front/new.html.erb (multi-value sections):
// - container id:  multiple_<fieldName>
// - add button:    .js-add-multivalue  data-field-name="<fieldName>"
// - remove button: .js-remove-multivalue

(() => {
  "use strict";

  if (window.__multivalueinputs_bound) return;
  window.__multivalueinputs_bound = true;

  const containerFor = (fieldName) => document.getElementById(`multiple_${fieldName}`);

  const inputsForField = (container, fieldName) => {
    const expectedName = `software_record[${fieldName}][]`;
    return Array.prototype.filter.call(
      container.querySelectorAll("input"),
      (input) => input.name === expectedName
    );
  };

  const nextIndex = (container, fieldName) => {
    const prefix = `software_record_${fieldName}_`;
    const inputs = inputsForField(container, fieldName);
    let max = 0;
    inputs.forEach((input) => {
      const id = input.id;
      if (id && id.startsWith(prefix)) {
        const n = parseInt(id.slice(prefix.length), 10);
        if (!Number.isNaN(n) && n > max) max = n;
      }
    });
    return max + 1;
  };

  function add(fieldName, value = "") {
    const container = containerFor(fieldName);
    if (!container) return;

    const index = nextIndex(container, fieldName);

    const row = document.createElement("div");
    row.className = "input-group mt-2";
    row.dataset.multivalueRow = "true";

    const input = document.createElement("input");
    input.type = "text";
    input.required = true;
    input.name = `software_record[${fieldName}][]`;
    input.id = `software_record_${fieldName}_${index}`;
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

  document.addEventListener("click", (e) => {
    const target =
      e.target instanceof Element ? e.target : e.target.parentElement;
    if (!target) return;

    const addBtn = target.closest(".js-add-multivalue");
    if (addBtn) {
      e.preventDefault();
      const fieldName = (addBtn.getAttribute("data-field-name") || "").trim();
      if (!fieldName) return;
      add(fieldName, "");
      return;
    }

    const removeBtn = target.closest(".js-remove-multivalue");
    if (removeBtn) {
      e.preventDefault();
      const row = removeBtn.closest(".input-group");
      if (row) row.remove();
    }
  });
})();
