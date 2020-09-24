const helloContainer = document.getElementById('hello-container')
const btnData = document.querySelector('.btn-fetch-data')
const noThanks = document.querySelector('.no-thanks')

const fuckYou = () => {
  event.currentTarget.innerText = "Fuck You, click on the button !"
  setTimeout(function tsa() { btnData.querySelector('h1').innerText = "Yes Boss" }, 900)
}

const dataLoading = () => {
  noThanks.remove()
  btnData.remove()

  helloContainer.insertAdjacentHTML('afterbegin',
    `<h1 class="big-title mt-3 text-white mb-3">Loading data...</h1>
    <h3 class="small-title inactive-color">It can take some time if you have a lot of tracks on your Spotify :)</h3>
  `
    )
}


const sayHello = () => {
  if (helloContainer) {
    noThanks.addEventListener('click', fuckYou)
    btnData.addEventListener('click', dataLoading)
  }
}


export { sayHello }
