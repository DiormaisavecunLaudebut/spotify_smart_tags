import { closeModal } from '../components/track-dropdown';

const btnSubmitModal = document.getElementById('btn-submit-create-playlist');
const toastHTML = `
<div id="loading-toaster" class="alert fade alert-simple alert-primary alert-dismissible text-left font__family-montserrat font__size-16 font__weight-light brk-library-rendered rendered show" role="alert" data-brk-library="component__alert">
  <button type="button" class="close font__size-18" data-dismiss="alert">
          <span  aria-hidden="true"><i class="fa fa-times alertprimary"></i></span>
          <span class="sr-only">Close</span>
        </button>
  <i class="start-icon fas fa-cloud-upload-alt"></i>
  Creating playlist...
</div>
`
const displayLoadingToast = () => {
  document.body.insertAdjacentHTML('afterbegin', toastHTML);
}

const closeAndConfirm = () => {
  closeModal();
  setTimeout(displayLoadingToast, 265)
}

const listenPlaylistCreation = () => {
  if (btnSubmitModal) btnSubmitModal.addEventListener('click', closeAndConfirm)
}

export { listenPlaylistCreation }
