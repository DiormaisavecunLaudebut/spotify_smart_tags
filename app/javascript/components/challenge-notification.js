import { removeNotification } from '../components/account-connectors'

const displayChallengeNotification = () => {
  removeNotification();

  const notification = `
  <div class="mnotification background-linear-success">
    <i class="fas fa-medal challenge-icon"></i>
    <p class="notification-text text-dark"><b>Daily challenge completed !</b> You're a good boy</p>
    <i class="text-white mr-1 fas fa-times text-dark"></i>
  </div>`

  document.body.insertAdjacentHTML('afterbegin', notification);
  const notif = document.querySelector('.mnotification');

  notif.addEventListener('click', removeNotification)
  setTimeout(removeNotification, 300000000)
}

export { displayChallengeNotification }
