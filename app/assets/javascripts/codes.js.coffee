jQuery ->
  $("a[rel^='prettyPhoto'] img.attach").parent("a[rel^='prettyPhoto']").prettyPhoto({theme: 'facebook', slideshow: 10000, autoplay_slideshow: false, deeplinking: false})

  pre = $('pre.highlight')
  pl = pre.length
  for i in [0...pl]
    pre[i].innerHTML = '<span class="line-number"></span>' + pre[i].innerHTML + '<span class="cl"></span>'
    num = pre[i].innerHTML.split(/\n/).length;
    for j in [1..num]
      line_num = pre[i].getElementsByTagName('span')[0];
      line_num.innerHTML += '<span>' + j + '</span>'

  $('.select_code').on 'click', () ->
    for i in [0 .. editors.length]
      editors[i].clearSelection
      i = $(@).attr 'data-id'
      editors[i].focus
      editors[i].selectAll
    return false

  $('.unfold_code').on 'click', () ->
    i = $(@).attr 'data-id'
    folded = $(@).text() == 'Развернуть код'
    editorHeight = $($('.editor').get(i)).attr('data-height')
    fullHeight = editors[i].getSession().getScreenLength() * editors[i].renderer.lineHeight + editors[i].renderer.scrollBar.getWidth()
    $('.editor').get(i).style.height =
      if folded && fullHeight > editorHeight
        fullHeight
      else
        editorHeight
    + 'px'
    editors[i].resize()
    editors[i].focus()
    $(@).text(
      if folded
        'Свернуть код'
      else
        'Развернуть код'
    )
    return false