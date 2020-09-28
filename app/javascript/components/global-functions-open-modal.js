const toggleModal = (modalId) => {
  const modal = document.getElementById(modalId)

  modal.classList.toggle('d-none')
}


export { toggleModal }
