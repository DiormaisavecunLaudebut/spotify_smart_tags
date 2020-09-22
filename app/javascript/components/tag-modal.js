import { disableScroll, enableScroll } from '../components/manage-scroll'

const closeIcon = document.querySelector('.close-icon');
const modal = document.querySelector('.bulk-tag-modal');
const btn = document.getElementById('bulk-tag');
const hiddenInputTags = document.getElementById('hidden-input-tags')

const closeTagModal = () => {
  enableScroll();

  btn.classList.remove('d-none')
  modal.style.transform = ""
  hiddenInputTags.value = ""

  const tags = Array.from(modal.querySelectorAll('.mtag'))
  const activeTags = tags.filter(e => !e.classList.value.includes('tag-inactive'))

  activeTags.forEach(tag => tag.click())

  setTimeout(function dnone() { modal.classList.add('d-none') }, 300)
  closeIcon.removeEventListener('click', closeTagModal)
}

const displayTagModal = () => {
  console.log('hi')
  disableScroll();

  btn.classList.add('d-none')
  modal.classList.remove('d-none');
  modal.style.transform = `translate(0, -${modal.offsetTop - window.scrollY}px`;

  closeIcon.addEventListener('click', closeTagModal)
}

const listenTagModal = () => {
  if (btn) btn.addEventListener('click', displayTagModal)
}


export { listenTagModal, closeTagModal }
