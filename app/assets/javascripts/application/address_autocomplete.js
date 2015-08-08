$(document).ready(function () {
  var defaultBounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(49.918678, 23.910728),
      new google.maps.LatLng(49.768662, 24.167058));
  var circle = new google.maps.Circle({
    center: google.maps.LatLng(49.8419071, 24.0315675),
    radius: 12
  });
  var service = new google.maps.places.AutocompleteService({
    types: ['address'],
    bounds: defaultBounds,
    componentRestrictions: {country: 'ua'}
  });

  $('.address').autocomplete({
    source: function (request, response) {
      var term = request.term;
      service.getPlacePredictions({
        input: term,
        types: ['address'],
        bounds: circle.getBounds(),
        componentRestrictions: {country: 'ua'}
      }, function (predictions, status) { //,  types: ['(cities)']
        if (status == google.maps.places.PlacesServiceStatus.OK) {
          var list = $.map(predictions, function (prediction) {
            var match = prediction.description.match(/^(.+)(, Львів, Львівська область, Україна|, Lviv, Lviv Oblast, Ukraine)$/);
            if (match) return match[1];
          });
          console.log(list);
          response(list);
        } else {
          response([]);
        }
      });
    }
  });
});