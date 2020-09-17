const closeModal = (e) => {
  const modal = document.querySelector('.my-modal');

  modal.style.transform = ""
  modal.style.top = ""
  enableScroll();
  setTimeout(function toggle() { modal.classList.add('d-none')}, 150);
}

export { closeModal };
