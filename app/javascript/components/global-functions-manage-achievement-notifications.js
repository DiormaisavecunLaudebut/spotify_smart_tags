import { removeNotification } from '../components/account-connectors'

const displayNotification = (icon, background, text) => {
  const notification = `
    <div class="mnotification ${background}">
      <i class="${icon}"></i>
      <p class="notification-text text-dark">${text}</p>
      <i class="text-white mr-1 fas fa-times text-dark"></i>
    </div>`

  removeNotification();
  document.body.insertAdjacentHTML('afterbegin', notification);
  const notif = document.querySelector('.mnotification');

  notif.addEventListener('click', removeNotification)
  setTimeout(removeNotification, 5000)
}


const displayStatusNotification = (status) => {
  const icon = 'fas fa-medal challenge-icon'
  const background = 'background-linear-success'
  const text = `You've reached <b> status ${status} !!</b> New features unlocked`

  displayNotification(icon, background, text)
}

const displayPointsNotification = (points) => {
  const icon = "fas fa-coins"
  const background = "background-points"
  const text = `<b>${points}</b> points earned !!!`

  displayNotification(icon, background, text)
}

const displayChallengeNotification = () => {
  const icon = "fas fa-medal challenge-icon"
  const background = "background-linear-success"
  const text = `<b>Daily challenge completed !</b> You're a good boy`

  displayNotification(icon, background, text)
}

const displayAchievementNotification = (status, statusChanged, challenge, points) => {
  if (statusChanged == 'true') {
    displayStatusNotification(status)
  } else if (challenge == 'true') {
    displayChallengeNotification()
  } else if (points != "0") {
    displayPointsNotification(points)
  }
}

export { displayAchievementNotification, displayNotification }
