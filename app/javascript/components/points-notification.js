import { removeNotification } from '../components/account-connectors'

const displayPointsNotification = (points) => {
  removeNotification();

  const notification = `
  <div class="mnotification background-points">
    <i class="fas fa-trophy trophy-points"></i>
    <p class="notification-text text-dark"><b>${points}</b> points earned !!!</p>
    <i class="text-white mr-1 fas fa-times text-dark"></i>
  </div>`

  document.body.insertAdjacentHTML('afterbegin', notification);
  const notif = document.querySelector('.mnotification');

  notif.addEventListener('click', removeNotification)
  setTimeout(removeNotification, 3000)
}

export { displayPointsNotification }
