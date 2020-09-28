import { disableScroll, enableScroll } from '../components/manage-scroll'

const background = document.getElementById('dark-background')
let modal = undefined

const closeThisModal = () => {
  modal.classList.toggle('d-none')
  background.classList.toggle('d-none')
  enableScroll()
}

const toggleModal = (modalId) => {
  modal = document.getElementById(modalId)

  if (modal.classList.value.includes('d-none')) {
    background.addEventListener('click', closeThisModal)
    disableScroll()
  } else {
    enableScroll()
    background.removeEventListener('click', closeThisModal)
  }

  modal.classList.toggle('d-none')
  background.classList.toggle('d-none')

}


export { toggleModal }
