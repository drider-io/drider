function onHashChange(e) {
  console.log(e);
  var match = window.location.hash.match(/req_map(.+)$/)
  if (match){
    var id = match[1];
    var canvas = $('#req_map'+id);
    if (!canvas.is(':visible')){
      canvas.show();
      var mapOptions = {
        center: {lat: 49.8419071, lng: 24.0315675},
        zoom: 12
      };
      var map = new google.maps.Map(canvas[0],
          mapOptions);
      map.data.setStyle(function(feature) {
        var markers = feature.getProperty('markers');
        var bounds = new google.maps.LatLngBounds ();
        $.each(markers, function(index, value){
          var marker = new google.maps.Marker(value);
          marker.setMap(map);
          var pos = new google.maps.LatLng (value.position.lat, value.position.lng);
          bounds.extend (pos);
        });
        map.fitBounds (bounds);


          var color = feature.getProperty('color');
        console.log(color);
          return {
            strokeColor: color
          };
      });

      map.data.loadGeoJson('/car_requests/'+id+'.json')
    }

  }
}
$(window).on('hashchange', onHashChange);
$( document ).ready(onHashChange);
