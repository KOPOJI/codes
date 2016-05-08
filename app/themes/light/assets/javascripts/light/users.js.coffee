jQuery ->
  $('#profilePage a.edit_info').click ->
    !$($(@).parent().children('input')).removeClass('hidden')
    $($(@).parent().children('input')).focus()
  $('#profilePage input').blur ->
    return if $(@).attr('type') != 'text'
    if @.value != $(@).parent().children('span').html()
      $('.edit_profile').submit()
    $(@).addClass('hidden')
    $(@).parent().children('span').html(@.value)