$( document ).ready(function() {
  var map = $('#map-canvas');

  var mapOptions = {
    scrollwheel: false,
    navigationControl: false,
    mapTypeControl: false,
    scaleControl: false,
    draggable: false,
    center: {lat: 49.8419071, lng: 24.0315675},
    zoom: 12
  };
  var map = new google.maps.Map(document.getElementById('map-canvas'),
      mapOptions);

  map.data.setStyle(function (feature) {
    var type = feature.getProperty('type');
    var markerOps = feature.getProperty('marker');
    var marker = new google.maps.Marker(markerOps);
    marker.setMap(map);

    if (markerOps.title){
      var infowindow = new google.maps.InfoWindow({
            content: markerOps.title
        });
      infowindow.open(map,marker);
    }


  });

  map.data.loadGeoJson('/lviv/events.json');

});

