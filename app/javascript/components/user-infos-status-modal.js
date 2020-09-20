const closeIcon = document.querySelector('.close-icon');
const statusTrigger = document.querySelector('.user-status-info');
const modal = document.querySelector('.user-status-modal')

const closeStatusModal = () => {
  enableScroll();
  modal.style.transform = ""

  setTimeout(function dnone() { modal.classList.add('d-none') }, 300)
  closeIcon.removeEventListener('click', closeTagModal)
}

const displayStatusModal = () => {
  modal.classList.remove('d-none')
  modal.style.transform = `translate(0, -${modal.offsetTop - window.scrollY}px`;
  disableScroll()

  closeIcon.addEventListener('click', closeStatusModal)
}

const listenStatusModal = () => {
  if (statusTrigger) statusTrigger.addEventListener('click', displayStatusModal)
}


export { listenStatusModal }
