var trackSelectedCount = 0
const bulkAction = document.getElementById('bulk-tag')

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

  if (trackSelectedCount == 0) displayBulkAction()

  bk.style.background = "rgba(198, 40, 50, 1)"
  iconCheck.style.zIndex = 10
  iconCheck.style.fontSize = "24px"

  trackSelectedCount += 1
}

function unselectTrack(bk) {
  var iconCheck = bk.firstElementChild

  if (trackSelectedCount == 1) removeBulkAction()

  bk.style.background = "none"
  iconCheck.style.zIndex = -1
  iconCheck.style.fontSize = "0"

  trackSelectedCount -= 1
}

function manageSelection(e) {
  var bk = e.currentTarget

  bk.classList.toggle('track-selected');
  bk.classList.value.includes('track-selected') ? selectTrack(bk) : unselectTrack(bk)

  bulkAction.innerText = trackSelectedCount >= 2 ? `Tag ${trackSelectedCount} tracks` : "Tag 1 track"
}


function listenCoverClick() {
  const coverBackground = document.querySelectorAll('.track-select-background')
  coverBackground.forEach(background => background.addEventListener('click', manageSelection))
}

export { listenCoverClick }

// rgba(198, 40, 50, 1);
