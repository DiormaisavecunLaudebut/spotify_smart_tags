const badges = document.querySelectorAll('.badge-filter');
const input = document.getElementById('input-filter');

const styleBadge = (badge) => {
  if (badge.classList.value.includes('light')) {
    badge.classList.remove('badge-light');
    badge.classList.add('badge-primary');
  } else if (badge.classList.value.includes('primary')) {
    badge.classList.remove('badge-primary');
    badge.classList.add('badge-light');
  } else {
    badge.classList.remove('badge-success');
    badge.classList.add('badge-light');
  }
}
const updateInputFormValue = (text) => {
  const val = input.value
  input.value = val.includes(text) ? val.replace(`${text},`, '') : val + `${text},`
}

const setupFilter = (e) => {
  const badge = e.currentTarget

  styleBadge(badge);
  updateInputFormValue(badge.innerText)
}

const applyFilter = () => {
  badges.forEach(badge => badge.addEventListener('click', setupFilter))
}

export { applyFilter }
