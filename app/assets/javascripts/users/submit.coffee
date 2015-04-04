@prevent_double_submit = (event) ->
  $('.c-btn--submit--single').val('送信中...')
  if $('.c-btn--submit--single').hasClass('disabled')
    event.preventDefault();
  $('.c-btn--submit--single').addClass('disabled')
  return

@prevent_double_submit_from_link_to = (number, event) ->
  if !confirm('本当に商品をキャンセルしますか？')
    event.preventDefault();
    event.stopPropagation();
    return false
  if $("a#"+number).hasClass('disabled')
    event.preventDefault();
    event.stopPropagation();
    # return false; May need for Android?
  $("a#"+number).addClass('disabled')
  return

$ -> #for safari
  window.onpageshow = (event) ->
    $('.c-btn--submit--single').removeClass('disabled')
    if event.persisted
      url = location.href
      if url.match(/cart/)
        $('.c-btn--submit--single').val('レジに進む')
      else if url.match(/checkout\/payment/) || url.match(/checkout\/confirm/)
        window.location.replace(/cart/)
      else if url.match(/addresses/)
        $('.c-btn--submit--single').val('登録する')
      else if url.match(/credit_cards/)
        $('.c-btn--submit--single').val('登録する')
    return