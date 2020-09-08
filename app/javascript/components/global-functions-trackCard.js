function pluralise(string, count) {
  if (count == 0) {
    return `aucun ${string}`
  } else if (count == 1) {
    return `1 string`
  } else {
    return `${count} ${string}s`
  }
}

function trackCard(track) {
  const name            =     track[0],
        artist          =     track[1],
        cover_url       =     track[2],
        external_url    =     track[3],
        id              =     track[4],
        tags            =     track[5],
        tagList         =     track.slice(5, track.length),
        randomString    =     Math.random().toString(36).substring(7),
        badges          =     tagList.map(e => `<span class="badge badge-pill mr-1 badge-light">${e}</span>`).join('')
  const subtitle = tags == '' ? 'No tag' : pluralise('tag', tagList.length)
  const card = `
<div class="row-container" data-track-id="${id}">
  <div class="row-cover" style="background-image: url(${cover_url})"></div>
  <div class="row-details">
    <span class="row-title active-color line-clamp">${name}</span>
    <span class="row-subtitle inactive-color">${artist}</span>
    <span
      class="row-subtitle inactive-color tag-count"
      data-toggle="collapse"
      data-target="#${randomString}"
      aria-expanded="false"
      aria-controls="${id}">
      ${subtitle}
    </span>
    <div class="collapse" id="${randomString}">${badges}</div>
  </div>
  <div class="d-flex align-items-center mr-2">
    <i class="fas fa-ellipsis-h inactive-color" style="position: relative;">
      <div class="my-dropdown-menu d-none">
        <p
          class="my-dropdown-item py-1 pl-2"
          data-toggle="modal"
          data-target="#exampleModal">
          Edit Tags
        </p>
        <p class="my-dropdown-item py-1 pl-2">Action 3</p>
        <a class="my-dropdown-item py-1 pl-2 text-black" href="${external_url}">Open in Spotify</a>
      </div>
    </i>
  </div>
</div>`
  return card
}

export { trackCard }
