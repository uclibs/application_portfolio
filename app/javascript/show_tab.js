import bootstrap from "./bootstrap_setup"

document.addEventListener("turbo:load", function () {
  const hash = window.location.hash
  if (!hash) return

  const tabList = document.querySelector("#softwareRecordTab, #SoftwareRecordsTab")
  if (!tabList) return

  const tabTrigger = Array.from(tabList.querySelectorAll('a[href^="#"]')).find(
    (link) => link.getAttribute("href") === hash
  )
  if (!tabTrigger) return

  bootstrap.Tab.getOrCreateInstance(tabTrigger).show()
})
