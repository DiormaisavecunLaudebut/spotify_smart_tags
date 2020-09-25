const addTagOption = document.getElementById('add-tags')
const searchbar = document.getElementById('searchbar')
const inputAutocomplete = document.getElementById('input-autocomplete')

const toggleSearch = () => {
  addTagOption.classList.toggle('mbt')
  searchbar.classList.toggle('d-none')
  inputAutocomplete.click()
  inputAutocomplete.focus()
  closeDropdownMenu()
}

const listenAddTagClick = () => {
  if (addTagOption) addTagOption.addEventListener('click', toggleSearch)
}

export { listenAddTagClick }
