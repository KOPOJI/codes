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