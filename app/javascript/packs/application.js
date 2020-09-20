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

// import { trackDropdown, updateDots } from "../components/track-dropdown";
import { autocomplete } from "../components/autocomplete-tags"
import { autocomplete2, pushNewTag, resetVariables, addTagToUserTags } from "../components/autocomplete2"
import { openTagTracks, unselectTrack } from '../components/open-tag-tracks'
import { trackCard } from "../components/global-functions-trackCard"
import { emptyStateHTML } from "../components/global-functions-emptyState"
import { listenCreatePlaylistModal, positionModal } from "../components/global-functions-create-playlist-modal"
import { managePlaylistCreationOptions } from "../components/manage-playlist-creation-options"
import { listenPlaylistCreation } from '../components/close-modal-after-create'
import { connectorPage } from '../components/connectors-page'
import { listenBadgeClick, updateMtags } from '../components/style-tags'
import { listenSearchFocus } from '../components/searchbar'
import { listenEllipsis } from '../components/track-modal'
import { disableScroll, enableScroll } from '../components/manage-scroll'
import { listenCoverClick } from '../components/select-track'
import { listenTagModal, closeTagModal } from '../components/tag-modal'
import { listenAccountToggles } from '../components/account-connectors'
import { listenOptions } from '../components/account-options'
import { listenStatusModal } from '../components/user-infos-status-modal'
import { displayAchievementNotification, displayNotification } from '../components/global-functions-manage-achievement-notifications'

autocomplete()
// trackDropdown();
openTagTracks()
managePlaylistCreationOptions()
listenPlaylistCreation()
connectorPage()
listenBadgeClick()
listenSearchFocus()
listenEllipsis()
listenTagModal()
listenAccountToggles()
listenOptions()
listenStatusModal()

if (window.location.href.match(/playlists\/\d+/)) {
  const closeIcon = document.querySelector('.close-icon.tag-modal-icon')
  listenCoverClick()
  closeIcon.addEventListener('click', closeTagModal)
}

global.trackCard = trackCard;
global.emptyStateHTML = emptyStateHTML
global.listenCreatePlaylistModal = listenCreatePlaylistModal
global.positionModal = positionModal
global.listenBadgeClick = listenBadgeClick
global.updateMtags = updateMtags
global.disableScroll = disableScroll
global.enableScroll = enableScroll
global.listenCoverClick = listenCoverClick
global.closeTagModal = closeTagModal
global.unselectTrack = unselectTrack
global.autocomplete2 = autocomplete2
global.displayAchievementNotification = displayAchievementNotification
global.pushNewTag = pushNewTag
global.resetVariables = resetVariables
global.addTagToUserTags = addTagToUserTags
global.displayNotification = displayNotification

// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';

// document.addEventListener('turbolinks:load', () => {
//   // Call your functions here, e.g:
//   // initSelect2();
// });
