import { updateDots } from '../components/track-dropdown'
import { unselectTrack } from '../components/select-track'

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
    const collapse = event.currentTarget.closest('.card').querySelector('.collapse')
    const cardBody = collapse.firstElementChild

    collapse.classList.toggle('show');
    if (!cardBody.classList.value.includes('data-loaded')) {
      cardBody.insertAdjacentHTML('afterbegin', spinner);
    } else {
      const backgrounds = cardBody.querySelectorAll('.track-selected')
      backgrounds.forEach(background => unselectTrack(background))
    }
    cardBody.classList.add('data-loaded');
  }))
}

export { openTagTracks, unselectTrack }
