document.addEventListener("turbo:load", function () {
  if (typeof bootstrap === "undefined") return;

  document.querySelectorAll(".flash-toast").forEach(function (element) {
    bootstrap.Toast.getOrCreateInstance(element).show();
  });
});
