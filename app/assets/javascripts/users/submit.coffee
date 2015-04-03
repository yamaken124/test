@prevent_double_submit = (event) ->
  $('.c-btn--submit').val('送信中...')
  if $('.c-btn--submit').hasClass('disabled')
    event.preventDefault();
  $('.c-btn--submit').addClass('disabled')
  return

@prevent_double_submit_from_link_to = (number, event) ->
  if $("a#"+number).hasClass('disabled')
    event.preventDefault();
    event.stopPropagation();
    # return false; May need for Android?
  $("a#"+number).addClass('disabled')
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