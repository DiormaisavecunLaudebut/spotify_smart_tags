// import { disableScroll, enableScroll } from '../components/manage-scroll'
// import { resetTags, displayExistingBadges, addParamsToInput, autocomplete } from '../components/autocomplete-tags'

// let dots = document.querySelectorAll('.fa-ellipsis-h');

// const modalHTML = `
// <div class="my-modal d-none">
//   <div class="badge-container"></div>
//   <form id="tags-form" method="post">
//     <input id="input-autocomplete" autocomplete="off" type="textarea" name="tags">
//     <input id="submit-tags" type="submit" name="commit" value="Save" class="btn btn-registration">
//   </form>
// </div>`

// const updateDots = () => {
//   dots = document.querySelectorAll('.fa-ellipsis-h');
//   trackDropdown();
// }



const closeModal = (e) => {
  const modal = document.querySelector('.my-modal');

  modal.style.transform = ""
  modal.style.top = ""
  enableScroll();
  setTimeout(function toggle() { modal.classList.add('d-none')}, 150);
}

// const openModal = (element) => {
//   const row = element.closest('.row-container');
//   row.insertAdjacentHTML('afterend', modalHTML);
//   const modal = document.querySelector('.my-modal');
//   const inputAutocomplete = document.getElementById('input-autocomplete');
//   const card = element.closest('.card')

//   modal.classList.remove('d-none');
//   modal.style.top = card ? window.scrollY - card.offsetTop + 40 + "px" : window.scrollY + 40 + "px";
//   inputAutocomplete.value = ""

//   const id = row.dataset.trackId
//   const form = document.getElementById('submit-tags');

//   form.formAction = `/tracks/${id}/tag`

//   const submitBtn = document.getElementById('submit-tags');
//   submitBtn.addEventListener('click', addParamsToInput);

//   displayExistingBadges(row);
//   autocomplete();
// }


// const performAction = (action, element) => {
//   if (action == "Edit Tags") {
//     openModal(element);
//     disableScroll();
//   }
// }

// const displayDropdown = (e) => {
//   const dropdown = e.currentTarget.querySelector('.my-dropdown-menu');
//   dropdown.classList.toggle('d-none');

//   if (e.target.classList.value.includes('dropdown-item')) performAction(e.target.innerHTML.trim(), e.target)
// }

// const trackDropdown = () => {
//   dots.forEach(dot => dot.addEventListener('click', displayDropdown))
// }



export { closeModal };
