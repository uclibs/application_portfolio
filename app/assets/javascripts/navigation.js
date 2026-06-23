function sidenavElement() {
  return document.getElementById("mySidenav");
}

function openNav() {
  const sidenav = sidenavElement();
  if (!sidenav) return;

  sidenav.style.visibility = "visible";
  sidenav.style.width = "250px";
}

function closeNav() {
  const sidenav = sidenavElement();
  if (!sidenav) return;

  sidenav.style.visibility = "hidden";
  sidenav.style.width = "0";
}

function resetMainLayout() {
  const main = document.getElementById("main");
  if (main) main.style.marginLeft = "";
}

document.addEventListener("turbo:load", resetMainLayout);
document.addEventListener("turbo:before-cache", resetMainLayout);
