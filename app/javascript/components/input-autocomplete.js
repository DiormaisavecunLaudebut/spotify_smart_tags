// ------------------------------- Class Autocomplete -------------------------------

class Autocomplete {
  constructor(userTags, usedTags, formPath, createTag) {
    this.userTags = userTags
    this.usedTags = usedTags
    this.formPath = formPath
    this.createTag = createTag
  }

  filterTags(text) {
    text = text.toLowerCase()

    return this.userTags.filter(tag => tag.includes(text)).filter(e => !this.usedTags.includes(e))
  }
}

// --------------------------- Variables ---------------------------------

let autocomplete = new Autocomplete()
let input = ""
let dropdownMenu = ""
let searchbar = ""

// ---------------------------- Initializers ---------------------------------

const initializeAutocomplete = (autocomplete, input, path, canCreate) => {
  autocomplete.formPath = path
  autocomplete.userTags = input.dataset.userTags.split('$$')
  autocomplete.usedTags = input.dataset.usedTags.split('$$')
  autocomplete.createTag = canCreate.toString() == "true"
}


const initializeVariables = (el) => {
  input = el
  searchbar = input.closest('.msearch')
  dropdownMenu = searchbar.querySelector('.my-dropdown-menu-autocomplete')
}


// --------------------------- Utilitaries functions --------------------

const clearDropdownMenu = () => {
  Array.from(dropdownMenu.children).forEach(e => e.remove())
}

const displayDropdownMenu = () => {
  dropdownMenu.classList.remove('d-none')
  searchbar.classList.add('top-radius')
}

const hideDropdownMenu = () => {
  dropdownMenu.classList.add('d-none')
  searchbar.classList.remove('top-radius')
  input.value = ""
}

const closeDropdownMenu = () => {
  clearDropdownMenu()
  hideDropdownMenu()
}

const buildBadges = (tags, boolean) => {
  if (autocomplete.formPath == "") {

    return tags.map((tag) => {
      const p = document.createElement('p')
      p.className = "my-dropdown-item-autocomplete py-1 pl-2"
      p.innerText = autocomplete.createTag  && boolean ? `create tag: ${tag}` : tag
      p.onclick = insertBadgeToContainer

      return p
    })

  } else {
    return tags.map((tag) => {
      const div = document.createElement('div')
      div.className = "my-dropdown-item-autocomplete py-1 pl-2"

      const form = document.createElement('form')
      form.setAttribute('action', autocomplete.formPath)
      form.setAttribute('data-remote', 'true')
      form.setAttribute('method', 'post')

      const hiddenInput = document.createElement('input')
      hiddenInput.setAttribute('type', 'hidden')
      hiddenInput.setAttribute('name', 'tag')
      hiddenInput.setAttribute('value', tag)

      const submitInput = document.createElement('input')
      const value = autocomplete.createTag && boolean ? `create tag: ${tag}` : tag
      submitInput.setAttribute('type', 'submit')
      submitInput.setAttribute('value', value)
      submitInput.id = `tag-${tag}`
      submitInput.className = "submit-item"

      form.appendChild(hiddenInput)
      form.appendChild(submitInput)
      div.appendChild(form)

      return div
    })
  }
}

// ----------------------------- Badge function --------------------------------------

const insertBadge = (name) => {
  const badgeContainer = document.querySelector('.badge-container')
  const div = document.createElement('div')
  const bigTags = badgeContainer.classList.value.includes('big-tags')

  div.className = bigTags ? "mtag tag-inactive" : "mtag-small"
  div.innerText = name
  div.onclick = styleTag

  badgeContainer.appendChild(div)
  div.click()
}

const insertBadgeToContainer = () => {
  const badgeName = event.currentTarget.innerText.replace('create tag: ', '')
  input.dataset.usedTags += `$$${badgeName}`

  closeDropdownMenu()
  insertBadge(badgeName)
}


// ----------------------------- Autocomplete functions -------------------------------

const appendDropdownItems = (tags, boolean) => {
  clearDropdownMenu()
  displayDropdownMenu()

  const badges = buildBadges(tags, boolean)
  badges.forEach(badge => dropdownMenu.appendChild(badge))
}

const displayAutocomplete = () => {
  const tags = autocomplete.filterTags(input.value)

  if (tags.length == 0 && autocomplete.createTag && input.value != "") { appendDropdownItems([input.value], true) }
  else if (input.value == "") { closeDropdownMenu()}
  else { appendDropdownItems(tags, false) }
}

const inputAutocomplete = (path, canCreate) => {
  initializeVariables(event.currentTarget)
  initializeAutocomplete(autocomplete, event.currentTarget, path, canCreate)
  input.addEventListener('input', displayAutocomplete)

}

export { inputAutocomplete, closeDropdownMenu }
