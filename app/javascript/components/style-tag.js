// ------------------------------- Variables --------------------------------

let badge = ""
let badgeContainer = ""
let hiddenInput = ""
let submitInput = ""

// ---------------------------------- Initializer ---------------------------------

const initializeTagVariables = (el) => {
  badge = el
  badgeContainer = badge.closest('.badge-container')
  hiddenInput = document.getElementById('hidden-input-tags')
  submitInput = document.getElementById('btn-submit-filter')
}

// --------------------------------- Utilitaries functions -----------------------

const deactivateTag = () => {
  const newValue = hiddenInput.value.replace(`${badge.innerText}$$`, '')

  hiddenInput.value = newValue
  badge.classList.add('tag-inactive')

}

const activateTag = () => {
  hiddenInput.value += `${badge.innerText}$$`
  badge.classList.remove('tag-inactive')
}

const activateSubmitInput = () => {
  if (hiddenInput.value != "" ) {
    submitInput.classList.remove('secondary-btn')
    submitInput.classList.add('primary-btn')
  } else {
    submitInput.classList.add('secondary-btn')
    submitInput.classList.remove('primary-btn')
  }
}

// ------------------------------------- Main function -------------------------------


const styleTag = () => {
  initializeTagVariables(event.currentTarget)
  const badgeActive = badge.classList.value.includes('tag-inactive')

  badgeActive ? activateTag() : deactivateTag()

  activateSubmitInput()
}


export { styleTag }
