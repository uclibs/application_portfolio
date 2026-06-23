// Specific to software_records index and list_upgrades filter UI.

function clearFiltersAndRedirect(targetPath) {
  const vendorFilter = document.getElementById("vendor-record-filter");
  const softwareTypeFilter = document.getElementById("software-type-filter");

  if (vendorFilter) vendorFilter.style.display = "none";
  if (softwareTypeFilter) softwareTypeFilter.style.display = "none";
  window.location = targetPath;
}

function handleRadio(myRadio) {
  const vendorFilter = document.getElementById("vendor-record-filter");
  const softwareTypeFilter = document.getElementById("software-type-filter");
  if (!vendorFilter || !softwareTypeFilter) return;

  if (myRadio.value === "vendor_records") {
    vendorFilter.style.display = "block";
    softwareTypeFilter.style.display = "none";
  } else {
    vendorFilter.style.display = "none";
    softwareTypeFilter.style.display = "block";
  }
}

window.clearFiltersAndRedirect = clearFiltersAndRedirect;
window.handleRadio = handleRadio;
