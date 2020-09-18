import { removeNotification } from '../components/account-connectors'

const options = document.querySelectorAll('.option-row')
const notif2 = `
<div class="mnotification background-mprimary">
  <p class="notification-text">We're not enough people to develop this feature.</p>
  <i class="text-white mr-1 fas fa-times"></i>
</div>`
const notif3 = `
<div class="mnotification background-mprimary">
  <p class="notification-text">I'm not a magician bro...</p>
  <i class="text-white mr-1 fas fa-times"></i>
</div>`
const notif4 = `
<div class="mnotification background-mprimary">
  <p class="notification-text">No I'm kidding, no one cares about your points</p>
  <i class="text-white mr-1 fas fa-times"></i>
</div>
`

const appendOptionNotification = (notif) => {
  removeNotification()

  document.body.insertAdjacentHTML('afterbegin', notif)
  const notification = document.querySelector('.mnotification')

  notification.addEventListener('click', removeNotification)
  setTimeout(removeNotification, 3000)
}

const displayOptionNotification = (e) => {
  if (e.currentTarget.id == "2") {
    appendOptionNotification(notif2)
  } else if (e.currentTarget.id == "3") {
    appendOptionNotification(notif3)
  } else if (e.currentTarget.id == "4") {
    appendOptionNotification(notif4)
  }
}

const listenOptions = () => {
  options.forEach(option => option.addEventListener('click', displayOptionNotification))
}

export { listenOptions }
