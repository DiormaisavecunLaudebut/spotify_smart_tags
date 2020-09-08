import { addBackground } from '../components/track-dropdown'
import { disableScroll } from '../components/manage-scroll'

function openCreatePlaylistModal(e) {
  const modal = document.querySelector('.my-modal');

  modal.style.top = window.scrollY + 40 + "px"
  modal.classList.remove('d-none');

  addBackground();
  disableScroll();
}

function listenCreatePlaylistModal() {
  const createPlaylistText = document.getElementById('open-create-playlist');
  createPlaylistText.addEventListener('click', openCreatePlaylistModal);
}



export { listenCreatePlaylistModal }
