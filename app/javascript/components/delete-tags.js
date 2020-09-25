const removeTagOption = document.getElementById('remove-tag')
const deleteTagsContainner = document.querySelector('.delete-tags-container')

const toggleContainer = () => {
  deleteTagsContainner.classList.toggle('d-none')
  deleteTagsContainner.classList.toggle('mbt')
  removeTagOption.classList.toggle('mbt')
}

const listenRemoveTagClick = () => {
  if (removeTagOption) removeTagOption.addEventListener('click', toggleContainer)
}

export { listenRemoveTagClick }
