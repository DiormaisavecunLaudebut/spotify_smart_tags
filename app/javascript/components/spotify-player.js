
// const spotifyPlayer = () => {
//   window.onSpotifyWebPlaybackSDKReady = () => {
//   const token = "BQAB2jqyjuMQKqa6w0XKzToinSpYZ3a1Fk_5GoX5pGaq4778o8ffjVB8t-ltZetm5OCWy7qAbA--CfBoZibBXeZtYg0Zc5KDq_Zhuo5nsb9RTHVt4aZI4WoSG8ctTlJVtPQXs4zucGNIN-fxNl9J_Knp0o1jy0w56w";
//   const player = new Spotify.Player({
//     name: 'Web Playback SDK Quick Start Player',
//     getOAuthToken: cb => { cb(token); }
//   });

//   // Error handling
//   player.addListener('initialization_error', ({ message }) => { console.error(message); });
//   player.addListener('authentication_error', ({ message }) => { console.error(message); });
//   player.addListener('account_error', ({ message }) => { console.error(message); });
//   player.addListener('playback_error', ({ message }) => { console.error(message); });

//   // Playback status updates
//   player.addListener('player_state_changed', state => { console.log(state); });

//   // Ready
//   player.addListener('ready', ({ device_id }) => {
//     console.log('Ready with Device ID', device_id);
//   });

//   // Not Ready
//   player.addListener('not_ready', ({ device_id }) => {
//     console.log('Device ID has gone offline', device_id);
//   });

//   // Connect to the player!
//   player.connect().then(success => {
//     if (success) {
//       console.log('The Web Playback SDK successfully connected to Spotify!')
//     }
//   });
// };
// }


// export { spotifyPlayer }
