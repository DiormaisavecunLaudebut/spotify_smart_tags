const searchInput = document.getElementById('input-autocomplete');


const switchSearchClass = (e) => {
  const search = e.currentTarget.parentElement
  const iconSearch = search.firstElementChild

  e.currentTarget.classList.toggle('text-white');
  iconSearch.classList.toggle('text-white');
  search.classList.toggle('search-focus');
}

const listenSearchFocus = () => {
  if (searchInput) {
    searchInput.addEventListener('focus', switchSearchClass)
    searchInput.addEventListener('focusout', switchSearchClass)
  }
}

export { listenSearchFocus }
