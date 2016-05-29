$(window).on 'load', ->
  $('.row.body').height(
    if $(document).height() > 650
      $(document).height() + 50
    else
      650
  )

jQuery ->
  $("a[rel^='prettyPhoto'] img.attach").parent("a[rel^='prettyPhoto']").fancybox()
  $('.toggle-nav-menu').on 'click', ->
    $('.nav-menu').toggle()
    if($('#page-content-wrapper').hasClass('col-md-10'))
      $('#page-content-wrapper').removeClass('col-sm-9 col-md-10 col-lg-10').addClass('col-sm-12 col-md-12 col-lg-12')
    else
      $('#page-content-wrapper').removeClass('col-sm-12 col-md-12 col-lg-12').addClass('col-sm-9 col-md-10 col-lg-10')


  $(window).on 'scroll', ->
    if $(window).scrollTop() > 100
      $('#top-link-block').hasClass('hidden') && $('#top-link-block').removeClass('hidden')
    else
      $('#top-link-block').addClass('hidden')

  $('#top-link-block').on 'click', ->
    $('html,body').animate({ scrollTop: 0 }, 700)
    return false
  $("#menu-toggle").on 'click', (e) ->
    e.preventDefault()
    $("#wrapper").toggleClass('toggled')