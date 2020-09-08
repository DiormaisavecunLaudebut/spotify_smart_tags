function emptyStateHTML(title, subtitle, btnText, btnHref) {
  const element = `
<div id="empty-state" class="mt-5 d-flex flex-column justify-content-center align-items-center">
  <h3 class="text-white">${title}</h3>
  <p style="margin: 0 15px; text-align: center">${subtitle}</p>
  <button href="${btnHref}" class="mt-2">${btnText}</button>
</div>
  `
  return element
}

export { emptyStateHTML }
