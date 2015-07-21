coords = false;
$(window).load(function() {
  $('#landing_search_from input').on('click', function () {
    if (!coords && navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function (position) {
        coords = true;
        $('#landing_search_from .hidden').val(position.coords.latitude + ' ' + position.coords.longitude)
      });
    }
  });
});
