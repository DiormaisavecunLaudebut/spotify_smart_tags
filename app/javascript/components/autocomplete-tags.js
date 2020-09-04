const inputAutocomplete = document.getElementById('input-autocomplete');
const user_tags = inputAutocomplete.dataset.listTags.split('/');
const badgeContainer = document.querySelector('.badge-container');
// const badge = `<span class="badge badge-pill badge-light"></span>`;

const appendDropdown = (suggs) => {
  console.log('inserting dropdown')
  const dropdownItems = suggs.map(sugg => `<p class="my-dropdown-item py-1 pl-2">${sugg}</p>`).join('');
  const dropdown =`<div class="my-dropdown-menu-autocomplete">${dropdownItems}</div>`;
  const modal = document.querySelector('.my-modal');
  modal.insertAdjacentHTML('beforeend', dropdown);
}

const addElementToDropdown = (element) => {
  const dropdown = document.querySelector('.my-dropdown-menu-autocomplete');
  dropdown.insertAdjacentHTML('afterbegin',`<p class="my-dropdown-item py-1 pl-2">${element}</p>`);
}

const editSuggestions = (suggs) => {
  const existingItems = Array.from(document.querySelector('.my-dropdown-menu-autocomplete').children)
  suggs.sort().forEach(sugg => {if (!existingItems.includes(sugg)) addElementToDropdown(sugg)})
  existingItems.forEach(item => {if (!suggs.includes(item.innerHTML)) item.remove()})
  // console.log(newDropdownItems)
}

const appendSuggestions = (suggs) => {
  const dropdownExists = document.querySelector('.my-dropdown-menu-autocomplete');
  dropdownExists ? editSuggestions(suggs) : appendDropdown(suggs)
}

const autocomplete = () => {
  if (inputAutocomplete) {
    inputAutocomplete.addEventListener('input', filterTags);
  }
}

const filterTags = (e) => {
  const inputValue = e.currentTarget.value;
  const tags = user_tags.filter(tag => tag.includes(inputValue)).sort();

  if (tags.length > 0 && inputValue != "") appendSuggestions(tags)
}

export { autocomplete };
