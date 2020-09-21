const today = () => {
  let today = new Date();
  const dd = today.getDate();
  const mm = today.getMonth()+1;
  const yyyy = today.getFullYear();
  const usedTags = badgesName.join(', ')

  return `${dd}/${mm}/${yyyy}`
}

export { today }
