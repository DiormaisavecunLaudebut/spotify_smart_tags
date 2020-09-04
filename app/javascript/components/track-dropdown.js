const dots = document.querySelectorAll('.fa-ellipsis-h');

const trackDropdown = () => {
  dots.forEach(dot => {
    dot.addEventListener('click', e => {
      const dropdown = e.currentTarget.querySelector('.my-dropdown-menu');
      dropdown.addEventListener('click', e => e.stopPropagation());
      dropdown.classList.toggle('d-none');
    })
  })
}


export { trackDropdown };
