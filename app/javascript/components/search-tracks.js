const smallRowContainer = document.getElementById('small-row-container')
const playlistSection = document.getElementById('my-playlists')
const searchSection = document.getElementById('my-search')
const searchBar = document.querySelector('.msearch')
const input = document.getElementById('input-search')
const form = document.getElementById('search-form')
const searchEmptyState = document.querySelector('.search-empty-state')
const emptyStateDescription = document.getElementById('emptystate-description')
const btnFilter = document.querySelector('.btn-filter')
const btnCancel = document.getElementById('cancel-btn')

function insertAfter(newNode, existingNode) {
    existingNode.parentNode.insertBefore(newNode, existingNode.nextSibling);
}


const toggleBody = () => {
  if (playlistSection.classList.value.includes('d-none')) {
    setTimeout(function blk() {
      searchBar.style.border = '1px solid #8D8D8D'
      input.style.color = '#8D8D8D'
      searchBar.querySelector('.fa-search').style.color = "#8D8D8D"
      insertAfter(btnFilter, searchBar)
      input.value = ""
      playlistSection.classList.remove('d-none')
      searchSection.classList.add('d-none')
      btnCancel.classList.add('d-none')
    })

  } else {
      searchBar.style.border = '1px solid white'
      input.style.color = 'white'
      searchBar.querySelector('.fa-search').style.color = "white"
      playlistSection.classList.add('d-none')
      searchSection.classList.remove('d-none')
      btnFilter.remove()
      btnCancel.classList.remove('d-none')
  }
}

const fireSearch = () => {
  Rails.fire(form, 'submit')

  if (event.currentTarget.value != "") {
    searchEmptyState.classList.add('d-none')
  } else {
    searchEmptyState.classList.remove('d-none')
    emptyStateDescription.innerText = 'Search Tracks by name or artist'
    Array.from(smallRowContainer.children).forEach(e => e.remove())
  }
}

const listenInputSearchTrack = () => {
  if (form) {
    input.addEventListener('focus', toggleBody)
    input.addEventListener('blur', toggleBody)
    input.addEventListener('input', fireSearch)
  }
}

export { listenInputSearchTrack }
