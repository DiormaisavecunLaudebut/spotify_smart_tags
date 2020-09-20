import { closeModal } from '../components/track-dropdown';

let inputAutocomplete = undefined
const hiddenTags = document.getElementById('hidden-list-tag');
const regex = />(.*)</

let badgeContainer = undefined
let usedTags = [];
let newTags = [];
let userTags = [];

document.addEventListener('click', e => {
  const dropdown = document.querySelector('.my-dropdown-menu-autocomplete2');
  if (dropdown && e.target.id != 'input-autocomplete') {
    if (!window.location.href.match('playlist')) dropdown.remove()
    document.querySelector('.msearch').classList.remove('top-radius')
  }
})

const insertNewBadges = (rowContainer) => {
  const badgesCollapse = rowContainer.querySelector('.collapse');

  newTags.forEach(tag => {
    const badge = `<span class="badge m-1 badge-pill badge-light">${tag}</span>`
    badgesCollapse.insertAdjacentHTML('beforeend', badge)
  })
}

const pushNewTag = (tag) => {
  usedTags.push(tag)
  newTags.push(tag)
}

const updateDataAttributes = (e) => {
  const row = e.currentTarget.closest('.my-modal').previousElementSibling
  const tagDetails = row.querySelector('.tag-count')

  insertNewBadges(row);

  tagDetails.innerText = usedTags.length + " tags"
}

const addParamsToInput = (element) => {
  inputAutocomplete.value = usedTags
  updateDataAttributes(element);
  setTimeout(closeModal, 50)
}

const displayExistingBadges = (row) => {
  badgeContainer = document.querySelector('.badge-container');
  const tags = Array.from(row.querySelectorAll('.badge-pill')).map(e => e.innerHTML)

  tags.forEach(tag => {
    usedTags.push(tag);
    const badge = `<span class="badge m-1 badge-pill badge-light">${tag}</span>`;
    badgeContainer.insertAdjacentHTML('beforeend', badge);
  })
}

const resetTags = () => {
  if (badgeContainer) {
    usedTags = []
    newTags = []
    Array.from(badgeContainer.children).forEach(e => e.remove());
  }
}

const addTagToUserTags = (tag) => {
  userTags.push(tag)
}

const resetVariables = () => {
  usedTags = []
  newTags = []
  userTags = []
}

const addExistingTag = (element) => {
  badgeContainer = document.querySelector('.badge-container')
  const tag = element.innerHTML
  usedTags.push(tag);
  newTags.push(tag);
  element.remove();
  inputAutocomplete.focus();
  updateMtags();

  if (!window.location.href.match('playlist')) {
    listenBadgeClick()
    badgeContainer.insertAdjacentHTML('beforeend', badge);
    Array.from(document.querySelectorAll('.mtag')).slice(-1)[0].click();
  }
}

const createTag = (element) => {
  const tag = element.childNodes[1].innerHTML
  const badge = `<div class="mtag tag-inactive">${tag}</div>`;

  usedTags.push(tag);
  newTags.push(tag);
  userTags.push(tag);
  inputAutocomplete.value = "";
  element.remove();
  badgeContainer.insertAdjacentHTML('beforeend', badge);
  inputAutocomplete.focus();
}

const insertTag = (e) => {
  e.stopPropagation();

  const item = e.target.classList.value.includes('autocomplete') ? e.target : e.target.parentElement
  item.classList.value.includes('create-tag') ? createTag(item) : addExistingTag(item)
}

const buildPath = () => {
  let path = ""
  if (window.location.href.match(/playlists\/.+/)) {
    const trackId = document.querySelector('.track-modal').dataset.trackId
    path = `/tracks/${trackId}/tag`
  } else {
    const playlistId = inputAutocomplete.dataset.playlistId
    path = `/playlists/${playlistId}/add-tag`
  }
  return path
}

const appendDropdown = (tags) => {
  let dropdownItems = ""
  let path = ""
  if (window.location.href.match('playlist')) {
    const path = buildPath()
    dropdownItems = tags.map(tag => `
      <form action="${path}" accept-charset="UTF-8" data-remote="true" method="post">
        <input type="hidden" name="tag" value="${tag}" id="tag-${tag}">
        <input type="submit" value="${tag}" class="my-dropdown-item-autocomplete2 submit-item">
      </form>
      `).join('')
  } else {
    dropdownItems = tags.map(tag => `<p class="my-dropdown-item-autocomplete2 py-1 pl-2">${tag}</p>`).join('');
  }
  let dropdown =`<div class="my-dropdown-menu-autocomplete2">${dropdownItems}</div>`;
  const searchbar = document.querySelector('.msearch');

  searchbar.insertAdjacentHTML('afterbegin', dropdown);
  searchbar.classList.add('top-radius')

  dropdown = document.querySelector('.my-dropdown-menu-autocomplete2');
  if (!window.location.href.match('playlist')) dropdown.addEventListener('click', insertTag);
}

const clearSuggestions = (tags) => {
  tags.forEach(tag => tag.remove())
}

const addTagToDropdown = (tag) => {
  const dropdown = document.querySelector('.my-dropdown-menu-autocomplete2');
  const playlistId = inputAutocomplete.dataset.playlistId

  if (window.location.href.match('playlist')) {
    const path = buildPath()
    dropdown.insertAdjacentHTML('afterbegin', `
      <form action="${path}" accept-charset="UTF-8" data-remote="true" method="post">
        <input type="hidden" name="tag" value="${tag}" id="tag-${tag}">
        <input type="submit" value="${tag}" class="my-dropdown-item-autocomplete2 submit-item">
      </form>
      `)
  } else {
    dropdown.insertAdjacentHTML('afterbegin',`<p class="my-dropdown-item-autocomplete2 py-1 pl-2">${tag}</p>`);
  }
}

const suggestTagCreation = (tag) => {
  const dropdown = document.querySelector('.my-dropdown-menu-autocomplete2');
  const playlistId = inputAutocomplete.dataset.playlistId
  const path = buildPath()

  dropdown.insertAdjacentHTML('afterbegin',
    `<form action="/playlists/${path}/add-tag" accept-charset="UTF-8" data-remote="true" method="post">
      <input type="hidden" name="tag" value="${tag}" id="tag-${tag}">
      <input type="submit" value="create tag: ${tag}" class="my-dropdown-item-autocomplete2 create-tag py-1 pl-2 submit-item">
    </form>`)
}

const updateDropdownItems = (items, tags) => {
  clearSuggestions(items)
  if (tags.length == 0 && window.location.href.match(/playlist|sptags/)) {
    suggestTagCreation(inputAutocomplete.value)
  } else {
    tags.reverse().forEach(tag => addTagToDropdown(tag));
  }
}

const filterTags = (e) => {
  const inputValue = e.currentTarget.value.toLowerCase();
  const tags = userTags.filter(tag => tag.includes(inputValue) && !usedTags.includes(tag)).sort().slice(0, 5);
  const dropdown = document.querySelector('.my-dropdown-menu-autocomplete2');

  if (dropdown) {
    const existingItems = Array.from(document.querySelector('.my-dropdown-menu-autocomplete2').children)
    inputValue == "" ? clearSuggestions(existingItems) : updateDropdownItems(existingItems, tags)
  } else {
    appendDropdown(tags);
  }
}

const autocomplete2 = () => {
  inputAutocomplete = document.getElementById('input-autocomplete2');
  userTags = inputAutocomplete ? hiddenTags.dataset.listTags.split(' ') : null
  if (inputAutocomplete) inputAutocomplete.addEventListener('input', filterTags);
}

export { autocomplete2, pushNewTag, resetVariables, addTagToUserTags };
