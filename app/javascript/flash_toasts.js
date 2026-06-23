import { Toast } from "bootstrap";

document.addEventListener("turbo:load", function () {
  document.querySelectorAll(".flash-toast").forEach(function (element) {
    Toast.getOrCreateInstance(element).show();
  });
});
