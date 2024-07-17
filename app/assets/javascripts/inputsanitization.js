var createdbyfield = document.getElementsByClassName('regex-createdby')[0];
createdbyfield.onkeyup = function() {
    createdbyfield.value = createdbyfield.value.replace(/[^a-zA-Z0-9 ]/, '');
}
