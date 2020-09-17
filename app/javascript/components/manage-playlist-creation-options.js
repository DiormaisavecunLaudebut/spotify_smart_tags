const publicCheckbox = document.getElementById('myonoffswitch0');
const toggles = document.querySelectorAll('.onoffswitch-label');
const errorMessage = document.getElementById('error-message')

if (publicCheckbox) publicCheckbox.checked = false

const checkOptions = (e) => {
  const publicOption = document.getElementById('myonoffswitch0').checked;
  const collaborativeOption = document.getElementById('myonoffswitch1').checked;
  const target = e.target.closest('.onoffswitch').nextElementSibling.innerText

  const check1 = publicOption == false && collaborativeOption == true && target == "Public"
  const check2 = publicOption == true && collaborativeOption == false && target == "Collaborative"
  if (check1 || check2) {
    e.preventDefault();
    console.log('hi')
    errorMessage.classList.remove('d-none')
  } else {
    if (errorMessage) errorMessage.classList.add('d-none');
  }
}

const managePlaylistCreationOptions = () => {
  if (!window.location.href.match('account')) {
    toggles.forEach(toggle => toggle.addEventListener('click', checkOptions))
  }
}


export { managePlaylistCreationOptions }
