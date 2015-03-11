@payment_method_change = (value) ->
  if value/1 == 1
    $('.js-credit').show()
  else
    $('.js-credit').hide()
  return
