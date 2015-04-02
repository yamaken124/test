@show_category = (form) ->
  sideWidth = $('.sidebar').outerWidth()
  openClass = 'open'
  speed=300
  if $(".sidebar").hasClass(openClass)
    $('body').css({'position', 'relative'})
    $('.sidebar').animate({'left' : (-1)*sideWidth }, speed);
    $(".js-fixed-contents").animate({'left' : 0 }, speed);
    $(".sidebar").toggleClass(openClass)
  else
    $('body').css({'position', 'fixed'})
    $(".js-fixed-contents").animate({'left' : sideWidth }, speed);
    $('.sidebar').animate({'left' : 0 }, speed);
    $(".sidebar").toggleClass(openClass)
  return

$ ->
  $('.js-fixed-contents').click (event) ->
    if $(".sidebar").hasClass(openClass) && !event.target.id.match('header__pull_down')
      sideWidth = $('.sidebar').outerWidth()
      $('body').css('position', 'relative')
      $('.sidebar').animate({'left' : -sideWidth }, speed);
      $(".js-fixed-contents").animate({'left' : 0 }, speed);
      $(".sidebar").toggleClass(openClass)
    return