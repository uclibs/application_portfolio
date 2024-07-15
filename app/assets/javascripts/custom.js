function openNav() {
    document.getElementById("mySidenav").style.visibility = "visible";
    document.getElementById("mySidenav").style.width = "250px";
    document.getElementById("main").style.marginLeft = "250px";
}

function closeNav() {
    document.getElementById("mySidenav").style.visibility = "hidden";
    document.getElementById("mySidenav").style.width = "0";
    document.getElementById("main").style.marginLeft = "0";
}

var dropdown = document.getElementsByClassName("dropdown-btn");
var i;
for (i = 0; i < dropdown.length; i++) {
    dropdown[i].addEventListener("click", function() {
        this.classList.toggle("active");
        var dropdownContent = this.nextElementSibling;
        if (dropdownContent.style.display === "block") {
            dropdownContent.style.display = "none";
        } else {
            dropdownContent.style.display = "block";
        }
    });
}

window.onload = function() {
    window.count_developers = 2;
    window.count_tech_leads = 2;
    window.count_departments = 2;
    window.count_product_owners = 2;
    window.count_admin_users = 2;
}

function add(name, value) {
    var element = document.createElement("div");
    var inputelement = document.createElement("input");
    var inputgroupappend = document.createElement("div");
    var spanelement = document.createElement("span");
    var removebutton = document.createElement("i");
    element.className = "input-group mt-2";
    if(name == "departments") {
        element.id = name + window.count_departments;
    }
    else if(name == "product_owners") {
        element.id = name + window.count_product_owners; 
    }
    else if(name == "admin_users") {
        element.id = name + window.count_admin_users; 
    }
    inputelement.type = "text";
    inputelement.required = true;
    if(value != "") {
        inputelement.innerHTML = value;
    }
    inputelement.name = "software_record[" + name + "][]";
    inputelement.id = "software_record_"+ name + "_" ;
    inputelement.className = "form-control";
    element.appendChild(inputelement);
    inputgroupappend.className = "input-group-append btnRemove";
    element.appendChild(inputgroupappend);
    spanelement.className = "input-group-text";
    inputgroupappend.appendChild(spanelement);
    removebutton.className = "fas fa-minus remove";
    removebutton.innerHTML = "  Delete";
    spanelement.appendChild(removebutton);
    inputgroupappend.onclick = function() {
        document.getElementById(element.id).remove();
    };
    var valued = "multiple_"+name;
    var multi_valued = document.getElementById(valued);
    multi_valued.appendChild(element);
}

document.getElementById("btnAddProductOwners").onclick = function() {
    add("product_owners", "");
    window.count_product_owners++;
};

document.getElementById("btnAddAdminUsers").onclick = function() {
    add("admin_users", "");
    window.count_admin_users++;
};

document.getElementById("btnAddDepartments").onclick = function() {
    add("departments", "");
    window.count_departments++;
};

function remove(id){
    document.getElementById(id).remove();
}

var createdbyfield = document.getElementsByClassName('regex-createdby')[0];
createdbyfield.onkeyup = function() {
    createdbyfield.value = createdbyfield.value.replace(/[^a-zA-Z0-9 ]/, '');
}

// Specific to software_records.html.erb
function clearFilters() {
    document.getElementById("vendor-record-filter").style.display = "none";
    document.getElementById("software-type-filter").style.display = "none";
    var loaded = window.location.host;
    window.location = "software_records";
}

function handleRadio(myRadio) {
    if(myRadio.value === "vendor_records") {
        document.getElementById("vendor-record-filter").style.display = "block";
        document.getElementById("software-type-filter").style.display = "none";
    } else {
        document.getElementById("vendor-record-filter").style.display = "none";
        document.getElementById("software-type-filter").style.display = "block";
    }
}

document.getElementById("btnAddDevelopers").onclick = function() {
    add("developers", "");
    window.count_developers++;
};

document.getElementById("btnAddTechLeads").onclick = function() {
    add("tech_leads", "");
    window.count_tech_leads++;
};

