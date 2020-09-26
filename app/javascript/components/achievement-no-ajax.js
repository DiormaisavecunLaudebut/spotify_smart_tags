import { displayAchievementNotification } from '../components/global-functions-manage-achievement-notifications'

const inputData = document.getElementById('manage_achievements')
let challengeCompleted = ""
let points = ""
let status = ""
let statusChanged = ""


const displayAchievementNotificationPostForm = () => {
  if (inputData) {
    challengeCompleted = inputData.dataset.challengeCompleted
    points = inputData.dataset.userPoints
    status = inputData.dataset.userStatus
    statusChanged = inputData.dataset.statusChanged

    if (points != "")  displayAchievementNotification(status, statusChanged, challengeCompleted, points)
  }
}

export { displayAchievementNotificationPostForm }
