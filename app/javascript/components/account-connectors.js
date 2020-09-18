const toggles = document.querySelectorAll('.onoffswitch');
const notification = `
<div class="mnotification background-mprimary">
  <p class="notification-text">For now it only works with Spotify, but if you'd like to connect your account to another app, send me a mail to <u>lior.levy@ehl.ch</u></p>
  <i class="text-white mr-1 fas fa-times"></i>
</div>`


const removeNotification = () => {
  const notif = document.querySelector('.mnotification')
  if (notif) notif.remove()
}

const displayNotification = (e) => {
  e.preventDefault()
  if (e.currentTarget.firstElementChild.name != 'Spotify') {
    removeNotification()

    document.body.insertAdjacentHTML('afterbegin', notification)
    const notif = document.querySelector('.mnotification')

    notif.addEventListener('click', removeNotification)

    setTimeout(removeNotification, 8000)
  }
}

const listenAccountToggles = () => {
  Array.from(toggles).slice(1, 3).forEach(toggle => toggle.firstElementChild.checked = false)

  if (window.location.href.match('account')) {
    toggles.forEach(toggle => toggle.addEventListener('click', displayNotification))
  }
}

export { listenAccountToggles, removeNotification }

