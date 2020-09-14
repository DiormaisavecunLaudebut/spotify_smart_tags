// // This file is automatically compiled by Webpack, along with any other files
// // present in this directory. You're encouraged to place your actual application logic in
// // a relevant structure within app/javascript and only use these pack files to reference
// // that code so it'll be compiled.

// require("@rails/ujs").start()
// require("turbolinks").start()
// require("@rails/activestorage").start()
// require("channels")


// // Uncomment to copy all static images under ../images to the output folder and reference
// // them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// // or the `imagePath` JavaScript helper below.
// //
// // const images = require.context('../images', true)
// // const imagePath = (name) => images(name, true)


// // ----------------------------------------------------
// // Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// // WRITE YOUR OWN JS STARTING FROM HERE 👇
// // ----------------------------------------------------

// // External imports
import "bootstrap";

import { trackDropdown, updateDots } from "../components/track-dropdown";
import { autocomplete } from "../components/autocomplete-tags";
import { openTagTracks } from '../components/open-tag-tracks';
import { trackCard } from "../components/global-functions-trackCard";
import { emptyStateHTML } from "../components/global-functions-emptyState";
import { listenCreatePlaylistModal, positionModal } from "../components/global-functions-create-playlist-modal";
import { managePlaylistCreationOptions } from "../components/manage-playlist-creation-options";
import { listenPlaylistCreation } from '../components/close-modal-after-create';
import { connectorPage } from '../components/connectors-page';
import { listenBadgeClick } from '../components/style-tags';
import { listenSearchFocus } from '../components/searchbar';

autocomplete();
trackDropdown();
openTagTracks();
managePlaylistCreationOptions();
listenPlaylistCreation();
connectorPage();
listenBadgeClick();
listenSearchFocus();

global.trackCard = trackCard;
global.emptyStateHTML = emptyStateHTML;
global.updateDots = updateDots;
global.listenCreatePlaylistModal = listenCreatePlaylistModal;
global.positionModal = positionModal;

// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';

// document.addEventListener('turbolinks:load', () => {
//   // Call your functions here, e.g:
//   // initSelect2();
// });
