import { disableScroll, enableScroll } from '../components/manage-scroll';

const modal = document.querySelector('.track-modal');
const points = document.querySelectorAll('.ellipsis-container');


const addTrackDetails = () => {
}

const displayTrackModal = () => {
  addTrackDetails();
  modal.classList.remove('d-none');
  modal.style.transform = `translate(0, -${modal.offsetTop - window.scrollY}px`;
  disableScroll();
}

const listenEllipsis = () => {
  // points.forEach(el => el.addEventListener('click', displayTrackModal))
}

export { listenEllipsis }
