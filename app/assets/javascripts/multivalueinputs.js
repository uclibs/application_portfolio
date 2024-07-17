window.onload = function() {
    window.counts = {
     
      developers: window.counts?.developers || 1,
      tech_leads: window.counts?.tech_leads || 1,
      departments: window.counts?.departments || 1,
      product_owners: window.counts?.product_owners || 1,
      admin_users: window.counts?.admin_users || 1
    
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
    inputElement.id = inputId; // Ensure unique ID for each input element
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
    
    // Update the onclick handler to directly remove the parent element
    inputGroupAppend.onclick = function() {
        element.remove();
    };
      
    var valued = "multiple_" + name;
    var multiValued = document.getElementById(valued);
    multiValued.appendChild(element);
}
 
document.getElementById("btnAddProductOwners").onclick = function() {
    add("product_owners", "");
};
  
document.getElementById("btnAddAdminUsers").onclick = function() {
    add("admin_users", "");
};
  
document.getElementById("btnAddDepartments").onclick = function() {
    add("departments", "");
};
  
document.getElementById("btnAddDevelopers").onclick = function() {
    add("developers", "");
};
  
document.getElementById("btnAddTechLeads").onclick = function() {
    add("tech_leads", "");
};
  
function remove(id) {
    document.getElementById(id).remove();
}
