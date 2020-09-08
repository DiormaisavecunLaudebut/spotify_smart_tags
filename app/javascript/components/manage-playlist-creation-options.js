const publicCheckbox = document.getElementById('myonoffswitch0');
const toggles = document.querySelectorAll('.onoffswitch-label');


const errorMessage = `
<div class="error-message-options">
  <i class="text-white fas fa-exclamation-triangle"></i>
  <p class="text-white">Public playlists cannot be collaboratives</p>
</di>
`

if (publicCheckbox) publicCheckbox.checked = false

const displayErrorMessage = () => {
  const modal = document.querySelector('.my-modal');
  modal.insertAdjacentHTML('afterbegin', errorMessage);
}

const checkOptions = (e) => {
  const publicOption = document.getElementById('myonoffswitch0').checked;
  const errorDisplayed = document.querySelector('.error-message-options');
  const collaborativeOption = document.getElementById('myonoffswitch1').checked;
  const target = e.target.closest('.onoffswitch').previousElementSibling.innerText
  const check1 = publicOption == false && collaborativeOption == true && target == "public"
  const check2 = publicOption == true && collaborativeOption == false && target == "collaborative"
  if (check1 || check2) {
    e.preventDefault();
    displayErrorMessage();
  } else {
    if (errorDisplayed) errorDisplayed.remove();
  }
}

const managePlaylistCreationOptions = () => {
  toggles.forEach(toggle => toggle.addEventListener('click', checkOptions))
}


export { managePlaylistCreationOptions }
