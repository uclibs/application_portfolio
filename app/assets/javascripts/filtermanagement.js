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
