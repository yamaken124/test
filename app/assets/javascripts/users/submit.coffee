@prevent_double_submit = (form) ->
  $('.c-btn--submit').val('送信中...')
  $('.c-btn--submit').disabled=true
  return

window.onpageshow = (event) ->
  if event.persisted
    url = location.href
    if url.match(/cart/)
      $('.c-btn--submit').val('レジに進む')
    else if url.match(/checkout\/payment/) || url.match(/checkout\/confirm/)
      window.location.replace(/cart/)
    else if url.match(/addresses\/new/)
      $('.c-btn--submit').val('登録する')
    else if url.match(/credit_cards\/new/)
      $('.c-btn--submit').val('登録する')
  return
