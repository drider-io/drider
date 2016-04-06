$('document').ready(function(){
  var value = parseInt($('.badge_ut').html());
  setAppBadge(value);
});

function setAppBadge(value){
  try {
    webkit.messageHandlers.callbackHandler.postMessage({
      badge_value: value
    });
    return false;
  } catch (err) {
    console.log('The native context does not exist yet');
  }

}
