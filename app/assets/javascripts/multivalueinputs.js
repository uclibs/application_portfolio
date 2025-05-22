window.onload = function () {
  window.counts = {
    developers: (window.counts && window.counts.developers) || 1,
    tech_leads: (window.counts && window.counts.tech_leads) || 1,
    departments: (window.counts && window.counts.departments) || 1,
    product_owners: (window.counts && window.counts.product_owners) || 1,
    admin_users: (window.counts && window.counts.admin_users) || 1
  };
};

function add(name, value) {
  var count = window.counts[name]++;
  var elementId = name + count;
  var inputId = "software_record_" + name + "_" + count;

  var element = document.createElement("div");
  element.className = "input-group mt-2";
  element.id = elementId;

  var inputElement = document.createElement("input");
  inputElement.type = "text";
  inputElement.required = true;
  inputElement.name = "software_record[" + name + "][]";
  inputElement.id = inputId;
  inputElement.className = "form-control";
  if (value != "") {
    inputElement.value = value;
  }
  element.appendChild(inputElement);

  var inputGroupAppend = document.createElement("div");
  inputGroupAppend.className = "input-group-append btnRemove";
  element.appendChild(inputGroupAppend);

  var spanElement = document.createElement("span");
  spanElement.className = "input-group-text";
  inputGroupAppend.appendChild(spanElement);

  var removeButton = document.createElement("i");
  removeButton.className = "fas fa-minus remove";
  removeButton.innerHTML = "  Delete";
  spanElement.appendChild(removeButton);

  inputGroupAppend.onclick = function () {
    element.remove();
  };

  var valued = "multiple_" + name;
  var multiValued = document.getElementById(valued);
  if (multiValued) {
    multiValued.appendChild(element);
  }
}

document.addEventListener("DOMContentLoaded", function () {
  var buttons = [
    ["btnAddProductOwners", "product_owners"],
    ["btnAddAdminUsers", "admin_users"],
    ["btnAddDepartments", "departments"],
    ["btnAddDevelopers", "developers"],
    ["btnAddTechLeads", "tech_leads"]
  ];

  buttons.forEach(function ([btnId, fieldName]) {
    var button = document.getElementById(btnId);
    if (button) {
      button.onclick = function () {
        add(fieldName, "");
      };
    }
  });
});

function remove(id) {
  var el = document.getElementById(id);
  if (el) {
    el.remove();
  }
}

