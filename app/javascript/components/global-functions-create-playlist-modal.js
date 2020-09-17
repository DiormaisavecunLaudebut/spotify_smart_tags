import { disableScroll } from '../components/manage-scroll'
import { closeModal } from '../components/track-dropdown';

const modal = document.querySelector('.my-modal');
const height = window.innerHeight
let position = 0

function positionModal() {
  const modal = document.querySelector('.my-modal');
  const btnHover = document.getElementById('open-create-playlist');
  const lastElement = document.body.lastElementChild
  position = lastElement.offsetTop

  modal.style.top = `${lastElement.offsetTop}px`
  btnHover.addEventListener('mouseover', e => modal.classList.toggle('d-none'))
  // btnHover.addEventListener('mouseout', e => modal.classList.toggle('d-none'))
}

function switchClass(e) {
  e.currentTarget.classList.toggle('text-white')
  e.currentTarget.classList.toggle('search-focus')
}

function openCreatePlaylistModal(e) {
  var covers = document.querySelectorAll('.track-select-background')
  covers.forEach(cover => cover.style.zIndex = 0)

  modal.classList.remove('d-none')
  modal.style.transform = `translate(0, -${position - window.scrollY}px)`
  document.querySelectorAll('.m-input').forEach(input => {
    input.addEventListener('focus', switchClass)
    input.addEventListener('focusout', switchClass)
  })
  document.querySelector('.close-icon').addEventListener('click', closeModal)
  disableScroll();
}

function listenCreatePlaylistModal() {

  const createPlaylistText = document.getElementById('open-create-playlist');
  createPlaylistText.addEventListener('click', openCreatePlaylistModal);
}


export { listenCreatePlaylistModal, positionModal }
