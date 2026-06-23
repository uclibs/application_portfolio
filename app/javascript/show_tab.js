import { Tab } from "bootstrap";

document.addEventListener("turbo:load", function () {
  const hash = window.location.hash;
  if (!hash) return;

  const tabList = document.querySelector("#softwareRecordTab, #SoftwareRecordsTab");
  if (!tabList) return;

  const tabTrigger = tabList.querySelector(`a[href="${hash}"]`);
  if (!tabTrigger) return;

  Tab.getOrCreateInstance(tabTrigger).show();
});
