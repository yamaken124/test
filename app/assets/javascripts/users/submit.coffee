@prevent_double_submit = (event) ->
  url = location.pathname
  if url.match(/checkout\/payment/)
    if !$("input:radio[name='order[address_id]']:checked").val()
      $('.address-highlighted').addClass('error_highlight')
      $('.c-payment_jquery_notice').text('お届け先が選択されていません')
      event.preventDefault();
      event.stopPropagation();
      return false

    if !$("input:radio[name='order[payment_attributes[gmo_card_seq_temporary]]']:checked").val()
      $('.credit-highlighted').addClass('error_highlight')
      $('.c-payment_jquery_notice').text('クレジットカードが選択されていません')
      event.preventDefault();
      event.stopPropagation();
      return false
  if url.match(/address/)
    firstZipcode = $('#address_first_zipcode').val()
    lastZipcode = $('#address_last_zipcode').val()
    if !( (firstZipcode.length==3) && (lastZipcode.length==4) )
      $('#zipcode_error_message').text('郵便番号が不正な値です')
      $('.jquery__address-zipcode').addClass('error_highlight')
      event.preventDefault();
      event.stopPropagation();
      return false

  if url.match(/show_one_click/)
    if !$("input:radio[name='order[[payment_attributes[gmo_card_seq_temporary]]']:checked").val()
      $('.credit-highlighted').addClass('error_highlight')
      $('.c-payment_jquery_notice').text('クレジットカードが選択されていません')
      event.preventDefault();
      event.stopPropagation();
      return false

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

$ ->
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