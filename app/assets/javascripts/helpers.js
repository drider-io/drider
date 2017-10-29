function messengerCloseWindow(){
  redirect = 'https://www.messenger.com/closeWindow/?image_url=https://drider.io/favicon.ico?&display_text=Це+вікно+можна+закрити';
  if (window.MessengerExtensions) {
    MessengerExtensions.requestCloseBrowser(function success() {
    }, function error(err) {
      window.location = redirect;
    });
  } else {
    window.location = redirect;
  }
}
