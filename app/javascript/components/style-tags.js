let mtags = document.querySelectorAll('.mtag');
const inputTags = document.getElementById('hidden-input-tags');
const submitBtn = document.getElementById('btn-submit-filter');
const maxFilters = document.getElementById('user-max-filters')

const updateMtags = () => {
  mtags = document.querySelectorAll('.mtag');
}

const toggleSubmitClass = () => {
  submitBtn.classList.toggle('primary-btn');
  submitBtn.classList.toggle('secondary-btn');
}

const applyStyle = (e) => {
  const tag = e.currentTarget;
  let max = ""
  let actual = ""
  if (!window.location.href.match(/playlist|sptags/)) {
    max = maxFilters.dataset.userMaxFilters
    actual = inputTags.value.split(',').length
  }

  if (!tag.classList.value.includes('tag-inactive')) {

    tag.classList.add('tag-inactive');
    const regex = new RegExp(`${tag.innerText},`);
    inputTags.value = inputTags.value.replace(regex, '')
    if (inputTags.value == "") toggleSubmitClass();

  } else if (!window.location.href.match('playlist') && actual > max) {

    const icon = ""
    const background = "background-linear-info"
    const text = "<b>Tag tracks</b> to use more tags, bitch!"

    displayNotification(icon, background, text)

  } else {

      tag.classList.remove('tag-inactive');
      inputTags.value += tag.innerText + ','
      if (!submitBtn.classList.value.includes('primary')) toggleSubmitClass()

  }

}


const listenBadgeClick = () => {
  if (mtags) mtags.forEach(tag => tag.addEventListener('click', applyStyle))
}

// export { listenBadgeClick, updateMtags }
