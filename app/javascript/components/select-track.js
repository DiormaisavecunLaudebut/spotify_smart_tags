var trackSelectedCount = 0
const bulkAction = document.getElementById('bulk-tag')
const hiddenInput = document.getElementById('hidden-input-user-tracks-ids')

function displayBulkAction() {
  const windowHeight = window.innerHeight
  const width = window.innerWidth * 0.1 / 2

  bulkAction.classList.remove('d-none')
  bulkAction.style.top = (windowHeight - 120 + "px")
  bulkAction.style.left = width + "px"
}

function removeBulkAction() {
  bulkAction.classList.add('d-none')
}

function selectTrack(bk) {
  var iconCheck = bk.firstElementChild
  const userTrackId = bk.closest('.row-container').dataset.userTrackId

  bk.classList.toggle('track-selected');
  hiddenInput.value += userTrackId + ','

  if (trackSelectedCount == 0) displayBulkAction()

  bk.style.background = "rgba(198, 40, 50, 1)"
  iconCheck.style.zIndex = 10
  iconCheck.style.fontSize = "24px"

  trackSelectedCount += 1
}

function unselectTrack(bk) {
  var iconCheck = bk.firstElementChild
  const userTrackId = bk.closest('.row-container').dataset.userTrackId
  const regex = new RegExp(`${userTrackId},`);

  bk.classList.toggle('track-selected');
  hiddenInput.value = hiddenInput.value.replace(regex, '')

  if (trackSelectedCount == 1) removeBulkAction()

  bk.style.background = "none"
  iconCheck.style.zIndex = -1
  iconCheck.style.fontSize = "0"

  trackSelectedCount -= 1
}

function manageSelection(e) {
  var bk = e.currentTarget

  bk.classList.value.includes('track-selected') ?  unselectTrack(bk) : selectTrack(bk)

  bulkAction.value = trackSelectedCount >= 2 ? `Tag ${trackSelectedCount} tracks` : "Tag 1 track"
}


function listenCoverClick() {
  const coverBackground = document.querySelectorAll('.track-select-background')
  coverBackground.forEach(background => background.addEventListener('click', manageSelection))
}

export { listenCoverClick, unselectTrack }
