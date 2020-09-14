import { disableScroll } from '../components/manage-scroll'
const modal = document.querySelector('.my-modal');
const height = window.innerHeight
let position = 0

function positionModal() {
  const modal = document.querySelector('.my-modal');
  const btnHover = document.getElementById('open-create-playlist');
  const lastRow = Array.from(document.querySelectorAll('.row-container')).slice(-1)[0]
  position = lastRow.offsetTop

  modal.style.top = `${lastRow.offsetTop}px`
  btnHover.addEventListener('mouseover', e => modal.classList.toggle('d-none'))
  btnHover.addEventListener('mouseout', e => modal.classList.toggle('d-none'))
}

function openCreatePlaylistModal(e) {
  modal.style.transform = `translate(0, -${position - window.scrollY}px)`

  disableScroll();
}

function listenCreatePlaylistModal() {

  const createPlaylistText = document.getElementById('open-create-playlist');
  createPlaylistText.addEventListener('click', openCreatePlaylistModal);
}


export { listenCreatePlaylistModal, positionModal }
