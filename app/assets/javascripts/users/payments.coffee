@payment_method_change = (value) ->
  if value/1 == 1
    $('.js-cresit').show()
  else
    $('.js-cresit').hide()
  return
