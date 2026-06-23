document.addEventListener("input", function (event) {
  const field = event.target
  if (!(field instanceof HTMLInputElement)) return
  if (!field.classList.contains("regex-createdby")) return

  field.value = field.value.replace(/[^a-zA-Z0-9 ]/g, "")
})
