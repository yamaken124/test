@show_category = (form) ->
  sideWidth = $('.sidebar').outerWidth()
  speed=300
  if $(".sidebar").hasClass('open')
    $(".js-fixed-contents").animate({'left' : 0 }, speed);
    $('.sidebar').animate({'left' : (-1)*sideWidth }, speed);
    $(".sidebar").toggleClass('open')
    $('body').css('position', '')
  else
    $(".js-fixed-contents").animate({'left' : sideWidth }, speed);
    $('.sidebar').animate({'left' : 0 }, speed);
    $(".sidebar").toggleClass('open')
    $('body').css('position', 'fixed')
  return

$ ->
  $('.js-fixed-contents').click (event) ->
    if $(".sidebar").hasClass('open') && !event.target.id.match('header__pull_down')
      speed=300
      sideWidth = $('.sidebar').outerWidth()
      $('.sidebar').animate({'left' : -sideWidth }, speed);
      $(".js-fixed-contents").animate({'left' : 0 }, speed);
      $(".sidebar").toggleClass('open')
      $('body').css('position', '')
      event.preventDefault();
      event.stopPropagation();
      return false
    return