const alignFixedBtn = (btn) => {
  const windowHeight = window.innerHeight
  const width = window.innerWidth * 0.1 / 2

  btn.style.top = `${windowHeight - 120}px`
  btn.style.left = `${width}px`
}


export { alignFixedBtn }
