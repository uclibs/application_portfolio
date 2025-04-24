document.addEventListener("turbolinks:load", function () {
  const hash = window.location.hash;
  if (hash) {
    const tabTrigger = document.querySelector(`a[href="${hash}"]`);
    if (tabTrigger) {
      const tab = new bootstrap.Tab(tabTrigger);
      tab.show();
    }
  }
});
