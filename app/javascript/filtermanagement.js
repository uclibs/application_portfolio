// Specific to software_records index and list_upgrades filter UI.

function clearFiltersAndRedirect(targetPath) {
  document.getElementById("vendor-record-filter").style.display = "none";
  document.getElementById("software-type-filter").style.display = "none";
  window.location = targetPath;
}

function handleRadio(myRadio) {
  if (myRadio.value === "vendor_records") {
    document.getElementById("vendor-record-filter").style.display = "block";
    document.getElementById("software-type-filter").style.display = "none";
  } else {
    document.getElementById("vendor-record-filter").style.display = "none";
    document.getElementById("software-type-filter").style.display = "block";
  }
}

window.clearFiltersAndRedirect = clearFiltersAndRedirect;
window.handleRadio = handleRadio;
