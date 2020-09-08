import { closeModal } from '../components/track-dropdown';

let inputAutocomplete = undefined
const hiddenTags = document.getElementById('hidden-list-tag');
const regex = />(.*)</

let badgeContainer = undefined
let usedTags = [];
let newTags = [];
let userTags = [];

document.addEventListener('click', e => {
  const dropdown = document.querySelector('.my-dropdown-menu-autocomplete');
  if (dropdown && e.target.id != 'input-autocomplete') dropdown.remove()
})

const insertNewBadges = (rowContainer) => {
  const badgesCollapse = rowContainer.querySelector('.collapse');

  newTags.forEach(tag => {
    const badge = `<span class="badge m-1 badge-pill badge-light">${tag}</span>`
    badgesCollapse.insertAdjacentHTML('beforeend', badge)
  })
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

const addExistingTag = (element) => {
  const tag = element.innerHTML
  const badge = `<span class="badge m-1 badge-pill badge-light">${tag}</span>`;

  usedTags.push(tag);
  newTags.push(tag);
  element.remove();
  badgeContainer.insertAdjacentHTML('beforeend', badge);
  inputAutocomplete.focus();
}

const createTag = (element) => {
  const tag = element.childNodes[1].innerHTML
  const badge = `<span class="badge m-1 badge-pill badge-light">${tag}</span>`;

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

const appendDropdown = (tags) => {
  const dropdownItems = tags.map(tag => `<p class="my-dropdown-item-autocomplete py-1 pl-2">${tag}</p>`).join('');
  let dropdown =`<div class="my-dropdown-menu-autocomplete">${dropdownItems}</div>`;
  const modal = document.querySelector('.my-modal');

  modal.insertAdjacentHTML('beforeend', dropdown);

  dropdown = document.querySelector('.my-dropdown-menu-autocomplete');
  dropdown.addEventListener('click', insertTag)
}

const clearSuggestions = (tags) => {
  tags.forEach(tag => tag.remove())
}

const addTagToDropdown = (tag) => {
  const dropdown = document.querySelector('.my-dropdown-menu-autocomplete');
  dropdown.insertAdjacentHTML('afterbegin',`<p class="my-dropdown-item-autocomplete py-1 pl-2">${tag}</p>`);
}

const suggestTagCreation = (tag) => {
  const dropdown = document.querySelector('.my-dropdown-menu-autocomplete');
  dropdown.insertAdjacentHTML('afterbegin',`<p class="my-dropdown-item-autocomplete create-tag py-1 pl-2">create tag <b>${tag}</b></p>`);
}

const updateDropdownItems = (items, tags) => {
  clearSuggestions(items);
  if (tags.length == 0) {
    suggestTagCreation(inputAutocomplete.value)
  } else {
    tags.reverse().forEach(tag => addTagToDropdown(tag));
  }
}

const filterTags = (e) => {
  const inputValue = e.currentTarget.value;
  const tags = userTags.filter(tag => tag.includes(inputValue) && !usedTags.includes(tag)).sort();
  const dropdown = document.querySelector('.my-dropdown-menu-autocomplete');

  if (dropdown) {
    const existingItems = Array.from(document.querySelector('.my-dropdown-menu-autocomplete').children)
    inputValue == "" ? clearSuggestions(existingItems) : updateDropdownItems(existingItems, tags)
    // updateDropdownItems(existingItems, tags)
  } else {
    appendDropdown(tags);
  }
}

const autocomplete = () => {
  inputAutocomplete = document.getElementById('input-autocomplete');
  userTags = inputAutocomplete ? hiddenTags.dataset.listTags.split(' ') : null

  if (inputAutocomplete) inputAutocomplete.addEventListener('input', filterTags);
}

export { autocomplete, resetTags, displayExistingBadges, addParamsToInput };
