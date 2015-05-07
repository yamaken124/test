$ ->
  max_width = $('#android_home_max_width').width()
  $('.p-home_common_height').height(max_width)
  wrapper_height = max_width+max_width+30
  $('.p-home_android_slides_ranking_wrapper').height(wrapper_height)
