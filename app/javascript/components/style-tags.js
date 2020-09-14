const mtags = document.querySelectorAll('.mtag');
const inputTags = document.getElementById('hidden-input-tags');

const applyStyle = (e) => {
  const tag = e.currentTarget;

  if (tag.classList.value.includes('tag-inactive')) {
    tag.classList.remove('tag-inactive');
    inputTags.value += tag.innerText + ','

  } else {
    tag.classList.add('tag-inactive');
    const regex = new RegExp(`${tag.innerText},`);
    inputTags.value = inputTags.value.replace(regex, '')
  }
}


const listenBadgeClick = () => {
  if (mtags) mtags.forEach(tag => tag.addEventListener('click', applyStyle))
}

export { listenBadgeClick }
