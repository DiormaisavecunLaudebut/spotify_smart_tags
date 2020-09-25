// ------------------------------- Variables --------------------------------

let badge = ""
let badgeContainer = ""
let hiddenInput = ""
let submitInput = ""

// ---------------------------------- Initializer ---------------------------------

const initializeTagVariables = (el, submitId) => {
  badge = el
  badgeContainer = badge.closest('.badge-container')
  submitInput = document.getElementById(submitId)
  hiddenInput = document.getElementById('hidden-input-tags')
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
    submitInput.classList.remove('d-none')
    submitInput.classList.remove('secondary-btn')
    submitInput.classList.add('primary-btn')
  } else {
    submitInput.classList.add('secondary-btn')
    submitInput.classList.remove('primary-btn')
  }
}

// ------------------------------------- Main function -------------------------------


const styleTag = (submitId) => {
  initializeTagVariables(event.currentTarget, submitId)
  const badgeActive = badge.classList.value.includes('tag-inactive')

  badgeActive ? activateTag() : deactivateTag()

  activateSubmitInput()
}


export { styleTag }
