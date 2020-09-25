const inputAutocomplete = document.getElementById('input-autocomplete');
let height_old = 0
let height_new = 0
let scroll_old = 0

const xfocus = () =>  {
  setTimeout(function() {
    height_old = window.innerHeight;
    scroll_old = window.scrollY
    window.addEventListener('resize', xresize);
  }, 500);
}

function xresize() {
  height_new = window.innerHeight;
  var diff = Math.abs(height_old - height_new);
  var perc = Math.round((diff / height_old) * 100);
  if (perc > 50) {
    xblur();
    window.removeEventListener('resize', xresize);
  }
}
function xblur() {
  window.scrollY = scroll_old
  window.removeEventListener('resize', xresize);
}

const listenKeyboardOnInput = () => {
  if (inputAutocomplete) {
    inputAutocomplete.addEventListener('click', xfocus)
    inputAutocomplete.addEventListener('blur', xblur)
  }
}

export { listenKeyboardOnInput }
