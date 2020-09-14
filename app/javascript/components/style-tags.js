const mtags = document.querySelectorAll('.mtag');
const inputTags = document.getElementById('hidden-input-tags');
const submitBtn = document.getElementById('btn-submit-filter');


const toggleSubmitClass = () => {
  submitBtn.classList.toggle('primary-btn');
  submitBtn.classList.toggle('secondary-btn');
}

const applyStyle = (e) => {
  const tag = e.currentTarget;

  if (tag.classList.value.includes('tag-inactive')) {
    tag.classList.remove('tag-inactive');
    inputTags.value += tag.innerText + ','
    if (!submitBtn.classList.value.includes('primary')) toggleSubmitClass()

  } else {
    tag.classList.add('tag-inactive');
    const regex = new RegExp(`${tag.innerText},`);
    inputTags.value = inputTags.value.replace(regex, '')
    if (inputTags.value == "") toggleSubmitClass();
  }
}


const listenBadgeClick = () => {
  if (mtags) mtags.forEach(tag => tag.addEventListener('click', applyStyle))
}

export { listenBadgeClick }
