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
        badges          =     tagList.map(e => `<span class="badge badge-pill mr-1 badge-light">${e}</span>`).join('')
  const subtitle = tags == '' ? 'No tag' : pluralise('tag', tagList.length)
  const card = `
<div class="row-container" style="padding: 0;" data-user-track-id="${id}">
<img class="row-cover" src="${cover_url}" alt="">
<div class="track-select-background"><i class="fas fa-check"></i></div>
  <a class="link-row" data-remote="true" href="/user_tracks/${id}/show-tags">
    <div class="row-details">
      <span class="row-title active-color line-clamp">${name}</span>
      <span class="row-subtitle">${artist}</span>
      <div class="mtag-small">${subtitle}</div>
    </div>
  </a>
</div>`

  return card
}

export { trackCard }
