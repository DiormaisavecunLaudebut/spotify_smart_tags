import { updateDots } from '../components/track-dropdown'

const cardHeaders = Array.from(document.querySelectorAll('.card-header'));
const spinner = `
<div class="spinner-container">
  <p class="active-color mt-3">Loading tracks...</p>
  <div class="mb-3 mt-1 spinner-border text-light spinner-border-sm" role="status">
    <span class="sr-only">Loading...</span>
  </div>
</div>
`

const openTagTracks = () => {
  cardHeaders.forEach(el => el.addEventListener('click', event => {
    const collapse = event.currentTarget.nextElementSibling;
    const cardBody = collapse.firstElementChild

    collapse.classList.toggle('show');
    if (!cardBody.classList.value.includes('data-loaded')) cardBody.insertAdjacentHTML('afterbegin', spinner);
    cardBody.classList.add('data-loaded');
  }))
}

// const callback = function(mutationsList, observer) {
//   for(let mutation of mutationsList) {
//     if (mutation.addedNodes.length > 1 && mutation.addedNodes[1].classList.value.includes('row-container')) {
//       updateDots();
//     }
//   }
// };


// const observer = new MutationObserver(callback);
// const config = { attributes: true, childList: true, subtree: true }

// const observeDOM = () => {
//   observer.observe(document, config)
// }

export { openTagTracks }
