const publicCheckbox = document.getElementById('myonoffswitch0');
const toggles = document.querySelectorAll('.onoffswitch-label');
const errorMessage = document.getElementById('error-message')
const status = document.getElementById('user-status')

if (publicCheckbox) publicCheckbox.checked = false

const checkOptions = (e) => {
  if (e.currentTarget.outerHTML.match('switch2') && status.dataset.userStatus != "music geek") {
    e.preventDefault()
    const icon = ""
    const background = "background-linear-info"
    const text = "<b>Tag tracks</b> and earn points to unlock this feature"

    displayNotification(icon, background, text)
  }
  const publicOption = document.getElementById('myonoffswitch0').checked;
  const collaborativeOption = document.getElementById('myonoffswitch1').checked;
  const target = e.target.closest('.onoffswitch').nextElementSibling.innerText

  const check1 = publicOption == false && collaborativeOption == true && target == "Public"
  const check2 = publicOption == true && collaborativeOption == false && target == "Collaborative"
  if (check1 || check2) {
    e.preventDefault();
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
