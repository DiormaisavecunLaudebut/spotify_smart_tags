const mtags = document.querySelectorAll('.mtag');

const applyStyle = (e) => {
  const tag = e.currentTarget;

  if (tag.classList.value.includes('tag-inactive')) {
    tag.classList.remove('tag-inactive');

  } else {
    tag.classList.add('tag-inactive');

  }
}


const listenBadgeClick = () => {
  if (mtags) mtags.forEach(tag => tag.addEventListener('click', applyStyle))
}

export { listenBadgeClick }
