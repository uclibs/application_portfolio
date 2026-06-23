function openNav() {
  document.getElementById("mySidenav").style.visibility = "visible";
  document.getElementById("mySidenav").style.width = "250px";
}

function closeNav() {
  document.getElementById("mySidenav").style.visibility = "hidden";
  document.getElementById("mySidenav").style.width = "0";
}

function resetMainLayout() {
  var main = document.getElementById("main");
  if (main) main.style.marginLeft = "0";
}

document.addEventListener("turbo:load", resetMainLayout);
document.addEventListener("turbo:before-cache", resetMainLayout);
