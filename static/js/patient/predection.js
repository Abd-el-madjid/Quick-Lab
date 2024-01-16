$(document).ready(function () {



// Get all the tab items and content wrappers
const tabItems = document.querySelectorAll('.vertical_tabs__nav-item-adfdw');
const contentWrappers = document.querySelectorAll('.vertical_tabs__content-wrapper-S8g2o');

// Add click event listeners to the tab items
tabItems.forEach((tabItem, index) => {
  tabItem.addEventListener('click', () => {
    // Remove "is-active-dNmCb" class from all tab items
    tabItems.forEach((item) => {
      item.classList.remove('is-active-dNmCb');
    });

    // Add "is-active-dNmCb" class to the clicked tab item
    tabItem.classList.add('is-active-dNmCb');

    // Remove "none" class from all content wrappers
    contentWrappers.forEach((wrapper) => {
      wrapper.classList.add('none');
    });

    // Add "none" class to the corresponding content wrapper based on the index
    contentWrappers[index].classList.remove('none');
  });
});

});




















window.onload = function() {
  var predictionPercentage = document.querySelector('#predictionPercentage');
  var percentageData = parseInt(predictionPercentage.getAttribute('data-percentage'));
 
  var ctx1 = predictionPercentage.getContext('2d');
  var myChart1 = new Chart(ctx1, {
    type: 'doughnut',
    data: {
        labels: ['Maladie', 'Not'],
        datasets: [{
            data: [percentageData, 100 - percentageData],
            backgroundColor: [
                'rgba(230, 31, 87, 0.2)',
                'rgba(54, 162, 235, 0.2)'
            ],
            borderColor: [
                'rgba(230, 31, 87, 1)',
                'rgba(54, 162, 235, 1)'
            ],
            borderWidth: 1
        }]
    },
    options: {
        plugins: {
            legend: {
                display: true,
                position: 'bottom',
            },
            tooltip: {
                callbacks: {
                    label: function(context) {
                        var index = context.dataIndex;
                        var value = context.dataset.data[index];
                        return ' ' + value + '%';
                    }
                }
            },
            animation: {
                duration: 5000, // Duration in milliseconds.
                easing: 'easeInOutCirc', // Easing function to use
                animateRotate: true, // Allow rotation animations
                animateScale: false, // Allow scale animations
            }
        },
        interaction: {
            mode: 'nearest',
            axis: 'x',
            intersect: false
        },
        responsive: true,
        maintainAspectRatio: false,
    }
});

  predictionPercentage.style.height = '320px';
  predictionPercentage.style.width = '320px';
  
  var predictionFeature = document.querySelector('#predictionFeature');
  var featureData = JSON.parse(predictionFeature.getAttribute('data-feature'));

  var labelData = JSON.parse(predictionFeature.getAttribute('data-label'));  // Corrected this line

  var ctx2 = predictionFeature.getContext('2d');
  var myChart2 = new Chart(ctx2, {
    type: 'bar',
    data: {
        labels: labelData,
        datasets: [{
            data: featureData,
            backgroundColor: [
                'rgba(255, 0, 0, 0.2)',      // Red
                'rgba(0, 255, 0, 0.2)',      // Green
                'rgba(0, 0, 255, 0.2)',      // Blue
                'rgba(255, 255, 0, 0.2)',    // Yellow
                'rgba(255, 0, 255, 0.2)',    // Magenta
                'rgba(0, 255, 255, 0.2)',    // Cyan
                'rgba(128, 128, 128, 0.2)',  // Gray
                'rgba(255, 165, 0, 0.2)',    // Orange
                'rgba(0, 128, 0, 0.2)',      // Dark Green
                'rgba(128, 0, 128, 0.2)',    // Purple
                'rgba(128, 0, 0, 0.2)',      // Maroon
                'rgba(0, 128, 128, 0.2)',    // Teal
                'rgba(0, 0, 128, 0.2)',      // Navy
                'rgba(255, 192, 203, 0.2)'   // Pink
            ],
            borderColor: [
                'rgba(255, 0, 0, 1)',        // Red
                'rgba(0, 255, 0, 1)',        // Green
                'rgba(0, 0, 255, 1)',        // Blue
                'rgba(255, 255, 0, 1)',      // Yellow
                'rgba(255, 0, 255, 1)',      // Magenta
                'rgba(0, 255, 255, 1)',      // Cyan
                'rgba(128, 128, 128, 1)',    // Gray
                'rgba(255, 165, 0, 1)',      // Orange
                'rgba(0, 128, 0, 1)',        // Dark Green
                'rgba(128, 0, 128, 1)',      // Purple
                'rgba(128, 0, 0, 1)',        // Maroon
                'rgba(0, 128, 128, 1)',      // Teal
                'rgba(0, 0, 128, 1)',        // Navy
                'rgba(255, 192, 203, 1)'     // Pink
            ],
            
            borderWidth: 1
        }]
    },
    options: {
        plugins: {
            legend: {
                display: false
            },
            tooltip: {
                callbacks: {
                    label: function(context) {
                        var index = context.dataIndex;
                        var value = context.dataset.data[index];
                        return ' ' + value;
                    }
                }
            },
            animation: {
                duration: 2000,
                easing: 'easeInOutCirc',
            }
        },
        interaction: {
            mode: 'nearest',
            axis: 'x',
            intersect: false
        },
        responsive: true,
        maintainAspectRatio: false,
        scales: {
            x: {
                beginAtZero: true
            },
            y: {
                beginAtZero: true
            }
        }
    }
});

  predictionFeature.style.height = '320px';
  predictionFeature.style.width = '320px';
};
