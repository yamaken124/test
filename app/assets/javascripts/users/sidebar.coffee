@show_category = (form) ->
  sideWidth = $('#sidebar').outerWidth()
  if !$("#sidebar").hasClass('open')
    $('body').css('position', 'fixed')
    $("#js-fixed-contents").animate({'left' : sideWidth }, 300);
    $('#sidebar').animate({'left' : 0 }, 300);
    $("#sidebar").toggleClass('open')
  else
    $('body').css('position', 'relative')
    $('#sidebar').animate({'left' : -sideWidth }, 300);
    $("#js-fixed-contents").animate({'left' : 0 }, 300);
    $("#sidebar").toggleClass('open')
  return

$ ->
  $('#js-fixed-contents').click (event) ->
    if $("#sidebar").hasClass('open') && !event.target.id.match('header__pull_down')
      sideWidth = $('#sidebar').outerWidth()
      $('body').css('position', 'relative')
      $('#sidebar').animate({'left' : -sideWidth }, 300);
      $("#js-fixed-contents").animate({'left' : 0 }, 300);
      $("#sidebar").toggleClass('open')
    return