$(function () {
  var canvas = $('.map-canvas');
  if (canvas.length > 0) {
    var mapOptions = {
      center: {lat: 49.8419071, lng: 24.0315675},
      zoom: 12,
      scrollwheel: false
    };
    var map = new google.maps.Map(canvas.get(0),
        mapOptions);
    var bounds = new google.maps.LatLngBounds();
    map.data.setStyle(function (feature) {
      var markers = feature.getProperty('markers');

      $.each(markers, function (index, value) {
        var marker = new google.maps.Marker(value);
        var infowindow = new google.maps.InfoWindow({
            content: value.title
          });
        marker.addListener('mouseover', function() {
            // marker.setIcon(icon2);
          infowindow.open(map, this);
        });
        marker.addListener('mouseout', function() {
            infowindow.close();
        });

        marker.setMap(map);
        var pos = new google.maps.LatLng(value.position.lat, value.position.lng);
        bounds.extend(pos);
      });
      // map.fitBounds(bounds);


      var color = feature.getProperty('color');
      console.log(color);
      return {
        strokeColor: color
      };
    });

    map.data.addListener('addfeature', function(e) {
      processPoints(e.feature.getGeometry(), bounds.extend, bounds);
      map.fitBounds(bounds);
    });
    map.data.loadGeoJson(window.location + '.json');


    function processPoints(geometry, callback, thisArg) {
      if (geometry instanceof google.maps.LatLng) {
        callback.call(thisArg, geometry);
      } else if (geometry instanceof google.maps.Data.Point) {
        callback.call(thisArg, geometry.get());
      } else {
        geometry.getArray().forEach(function(g) {
          processPoints(g, callback, thisArg);
        });
      }
    }
  }
});
