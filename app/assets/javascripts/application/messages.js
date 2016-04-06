function on_message(from_id){
  function setBadge(target, value){
    target.html(value);
    if (value>0) {
      target.removeClass('hide')
    } else {
      target.addClass('hide')
    }
  }
  var match = window.location.pathname.match(/messages\/(\d+)/);
  var cmt_id = match ? match[1] : '';

  $.get('/messages/'+from_id+'.json?cmt_id='+cmt_id).success(function(data){
    console.log(data);
    setBadge($('.badge_ut'), data.ut);
    setAppBadge(data.ut);
    setBadge($('.badge_urc'), data.urc);
    setBadge($('.badge_umc'), data.umc);
    if (data.messages_html){
      $('.messages-list').html(data.messages_html);
    }
  })
}
