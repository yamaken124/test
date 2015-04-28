$(window).load ->
	$('.flexslider').flexslider animation: 'slide'
	return

@update_max_used_point = (event) ->
  quantity = $('#order_item_count').val()
  variantId = $('#order_item_attributes_variant_id').val()
  $.ajax
    async:    true
    url:      "/products/update_max_used_point/"
    type:     "GET"
    data:     {quantity: quantity, variant_id: variantId}
    dataType: "json"
    context:  this
    success: (data) ->
      $('.update_max_used_point').html(data)
  return
