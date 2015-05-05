$ ->
  max_width = $('#item_with_max_width').width()
  title_height = $('.c-product__bottom_wrapper').height()
  title_long_height = $('.c-product__bottom_wrapper_long').height()
  $('.c-product').height(max_width + title_height)
  $('.c-product_long').height(max_width + title_long_height)
  $('.c-product__image').height(max_width)