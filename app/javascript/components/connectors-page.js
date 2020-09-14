const toggles = document.querySelectorAll('.onoffswitch-checkbox');
const url = `https://accounts.spotify.com/authorize?client_id=815d14d339184ba78c0d71ef9865863d&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth%2Fspotify%2Fcallback&response_type=code&scope=playlist-read-private+playlist-read-collaborative+playlist-modify-public+playlist-modify-private+user-library-modify+user-library-read+ugc-image-upload+user-read-private+user-read-email&show_dialog=false`

const connectorPage = () => {
  if (toggles) {
    toggles.forEach(toggle => { toggle.checked = false });

    const spotify = document.querySelector("input[name='Spotify']")
    if (spotify) spotify.addEventListener('click', e => setTimeout(redirecToAuth, 150))
  }
}

function redirecToAuth() {
  window.location.href = url
}
export { connectorPage }
