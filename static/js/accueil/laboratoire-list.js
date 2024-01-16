function init() {


// Attach a keyup event listener to the search input field




    }


  function nav() {  
    $("#hamb").toggleClass('show');
        $("#close").toggleClass('show');
        
     $(".header-links").toggleClass('clicked');
    console.log(" profile info open ") ;
    }


document.querySelectorAll('.star-widget').forEach(function(widget) {
  var starsNumberInput = widget.querySelector('.stars_number');
  var rateInputs = widget.querySelectorAll('input[type="radio"]');
  var labels = widget.querySelectorAll('label');
  var laboId = widget.querySelector('[name="branche_id"]').value.split('-')[2]; // Extract the labo ID from the "branche_id" input value
  var previousIndex = -1;
  var isClicked = false;

  // Hovering behavior
  rateInputs.forEach(function(radio, index) {
    var labelFor = 'rate-' + (index + 1) + '-' + laboId; // Construct the label's "for" attribute value based on labo ID
    var inputId = 'rate-' + (index + 1) + '-' + laboId; // Construct the input's ID value based on labo ID
    labels[index].setAttribute('for', labelFor); // Set the "for" attribute of the label
    radio.setAttribute('id', inputId); // Set the ID of the input

    labels[index].addEventListener('mouseenter', function() {
      // Apply hover effect only if no star is clicked
      if (!isClicked) {
        // Color the hovered star and the stars to the right
        for (var i = index; i >= 0; i--) {
          labels[i].style.color = '#E61F57';
        }
      } else {
        // Color the stars greater than the clicked star only on hover
        if (index > previousIndex) {
          labels[index].style.color = '#E61F57';
        }
      }
    });
    labels[index].addEventListener('mouseleave', function() {
      // Remove color from all the stars that are not checked or clicked
      if (!rateInputs[index].checked && !isClicked) {
        for (var i = index; i >= 0; i--) {
          labels[i].style.color = '';
        }
      }
    });

    // Checked behavior
    radio.addEventListener('change', function() {
      // Get the selected star rating and update the related hidden input field
      var starRating = this.value;
      starsNumberInput.value = starRating;
      isClicked = true;

      // Color the clicked star and the stars to the left
      for (var i = index; i >= 0; i--) {
        labels[i].style.color = '#E61F57';
      }

      // Remove color from the rest of the stars
      for (var i = index + 1; i < rateInputs.length; i++) {
        labels[i].style.color = '';
      }

      // Add text shadow to the last star if it's checked
      if (index === 4) { // If "input#rate-5:checked"
        labels[index].style.textShadow = '0px 0px 4px #333';
      }

      // Remove color and text shadow from the previously clicked star
      if (previousIndex !== -1 && previousIndex !== index) {
        labels[previousIndex].style.color = '';
        labels[previousIndex].style.textShadow = '';
      }

      previousIndex = index;
    });
  });
});



















    var map = new ol.Map({
        target: 'map',
        layers: [
            new ol.layer.Tile({
                source: new ol.source.OSM()
            })
        ],
        view: new ol.View({
            center: ol.proj.fromLonLat([37.41, 8.82]),  // initial coordinates
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

 






// Attach a click event listener to all div elements with class "dl-search-result"
window.onload = function() {
    // Attach a marker to each div with class "dl-search-result"
    document.querySelectorAll(".location").forEach(function(div) {
        // Find the latitude and longitude input fields within the clicked div
        var latInput = div.querySelector('input[name="lat"]');
        var lonInput = div.querySelector('input[name="lon"]');

        // Retrieve the latitude and longitude values
        var lat = latInput ? latInput.value : null;
        var lon = lonInput ? lonInput.value : null;

        // Add the marker
        if (lat && lon) {
            addMarker(lon, lat);
        }

        // Add click listener to div
        div.addEventListener('click', function() {
            if (lat && lon) {
              updateLocation(lon, lat);
               layer.setStyle(hoverMarkerStyle);
            }
        });
          
    });
}


   updateLocation( 6.570059939966139,36.246118493580234);  // New York
   




































        // Get all dl-search-result elements
     var results = document.querySelectorAll('.dl-search-result');

// Create a chart for each dl-search-result
results.forEach(function(result, index) {
    var starData = JSON.parse(result.getAttribute('data-star'));
    var ctx = result.querySelector('canvas').getContext('2d');

    var myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['1 Star', '2 Stars', '3 Stars', '4 Stars', '5 Stars'],
            datasets: [{
                data: starData,
                backgroundColor: [
                    'rgba(230, 31, 87, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)'
                ],
                borderColor: [
                    'rgba(230, 31, 87,1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)'
                ],
                borderWidth: 1
            }]
        },
        options: {
            plugins: {
                legend: {
                    display: false
                }
            },
            interaction: {
                mode: 'nearest',
                axis: 'x',
                intersect: false
            }
        }
    });
});























