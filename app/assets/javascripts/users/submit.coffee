@prevent_double_submit = (event) ->
  $('.c-btn--submit').val('送信中...')
  if $('.c-btn--submit').hasClass('disabled')
    event.preventDefault();
  $('.c-btn--submit').addClass('disabled')
  return

$ -> #for safari
  window.onpageshow = (event) ->
    $('.c-btn--submit').removeClass('disabled')
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