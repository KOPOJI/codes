$(window).on 'load', ->
  $('.row.body').height(
    if $(document).height() > 650
      $(document).height() + 50
    else
      650
  )

jQuery ->
  $("a[rel^='prettyPhoto'] img.attach").parent("a[rel^='prettyPhoto']").fancybox()


  $(window).on 'scroll', ->
    console.log $(window).scrollTop()
    if $(window).scrollTop() > 100
      $('#top-link-block').hasClass('hidden') && $('#top-link-block').removeClass('hidden')
    else
      $('#top-link-block').addClass('hidden')

  $('#top-link-block').on 'click', ->
    $('html,body').animate({ scrollTop: 0 }, 700)
    return false