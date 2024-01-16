var map = new ol.Map({
  target: 'map',
  layers: [
    new ol.layer.Tile({
      source: new ol.source.OSM()
    })
  ],
  view: new ol.View({
    center: ol.proj.fromLonLat([37.41, 8.82]), // initial coordinates
    zoom: 10
  })
});

var defaultMarkerStyle = new ol.style.Style({
  image: new ol.style.Icon({
    anchor: [0.5, 1],
    src: '/media/image/pointeur.png'
  })
});

var hoverMarkerStyle = new ol.style.Style({
  image: new ol.style.Icon({
    anchor: [0.5, 1],
    src: '/atelier img/placeholder.png' // Change the marker image source for hover style
  })
});

function addMarker(lon, lat) {
  var layer = new ol.layer.Vector({
    source: new ol.source.Vector({
      features: [
        new ol.Feature({
          geometry: new ol.geom.Point(ol.proj.fromLonLat([lon, lat]))
        })
      ]
    }),
    style: defaultMarkerStyle // Set the default marker style initially
  });

  map.addLayer(layer);
}

function updateLocation(lon, lat) {
  var view = map.getView();
  view.setCenter(ol.proj.fromLonLat([lon, lat]));
  addMarker(lon, lat);
  view.animate({
    center: ol.proj.fromLonLat([lon, lat]),
    zoom: 14,
    duration: 200
  });
}

// Retrieve the latitude and longitude from the data attributes of the map element
var mapElement = document.querySelector('.map');
var lat = parseFloat(mapElement.dataset.mapLat);
var lon = parseFloat(mapElement.dataset.mapLon);

// Check if the latitude and longitude are valid numbers
if (!isNaN(lat) && !isNaN(lon)) {
  // Call the updateLocation function with the provided latitude and longitude
  updateLocation(lon, lat);
}



