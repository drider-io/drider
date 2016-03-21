function mobile_fb_login(){
  if (window.injectedAndroid) { window.injectedAndroid.login(); return false };
  document.write(window.webkit.messageHandlers.callbackHandler);
  return false;
}
