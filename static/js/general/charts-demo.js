'use strict';

/* Chart.js docs: https://www.chartjs.org/ */

window.chartColors = {
 green: 'rgba(117, 193, 129, 0.5)',
  blue: 'rgba(91, 153, 234, 0.5)',
  gray: 'rgba(169, 181, 201, 0.5)',
  red: 'rgba(255, 0, 0, 0.5)',
  yellow: 'rgba(255, 255, 0, 0.5)',
  purple: 'rgba(128, 0, 128, 0.5)',
  orange: 'rgba(255, 165, 0, 0.5)',
  pink: 'rgba(255, 105, 180, 0.5)',
  cyan: 'rgba(0, 255, 255, 0.5)',
  teal: 'rgba(0, 128, 128, 0.5)',
  indigo: 'rgba(75, 0, 130, 0.5)',
  brown: 'rgba(165, 42, 42, 0.5)',
  magenta: 'rgba(255, 0, 255, 0.5)',
  lime: 'rgba(0, 255, 0, 0.5)',
  olive: 'rgba(128, 128, 0, 0.5)',
  maroon: 'rgba(128, 0, 0, 0.5)',
  navy: 'rgba(0, 0, 128, 0.5)',
  salmon: 'rgba(250, 128, 114, 0.5)',
  gold: 'rgba(255, 215, 0, 0.5)',
  lavender: 'rgba(230, 230, 250, 0.5)'
};

const baseColor = window.chartColors.gray;

// Generate a color scale with opacity 1
const colorScaleOpacity1 = chroma.scale([chroma(baseColor).alpha(1), chroma(baseColor).brighten(2).alpha(1)]).colors(20);

// Generate a color scale with opacity 0.5
const colorScaleOpacity0_5 = chroma.scale([chroma(baseColor).alpha(0.5), chroma(baseColor).brighten(2).alpha(0.5)]).colors(20);

/* Random number generator for demo purpose */
var chart1_main = document.querySelector('#chart-1');
var chart1Data = JSON.parse(chart1_main.getAttribute('data-chart1'));
var chart1name = JSON.parse(chart1_main.getAttribute('data-name1'));
var ctx1 = chart1_main.getContext('2d');

var lineChartConfig = new Chart(ctx1, {
  type: 'line',
  data: {
    labels: chart1name,
    datasets: [{
      label: 'number appointment',
      backgroundColor: colorScaleOpacity0_5,
      borderColor: colorScaleOpacity1,
      data: chart1Data,
    }]
  },
  options: {
    responsive: true,
    legend: {
      display: true,
      position: 'bottom',
      align: 'end',
    },
    tooltips: {
      mode: 'index',
      intersect: false,
      titleMarginBottom: 10,
      bodySpacing: 10,
      xPadding: 16,
      yPadding: 16,
      borderColor: window.chartColors.border,
      borderWidth: 1,
      backgroundColor: '#fff',
      bodyFontColor: window.chartColors.text,
      titleFontColor: window.chartColors.text,
      callbacks: {
        label: function (tooltipItem, data) {
          return tooltipItem.value + '%';
        }
      },
    },
    hover: {
      mode: 'nearest',
      intersect: true
    },
    scales: {
      xAxes: [{
        display: true,
        gridLines: {
          drawBorder: false,
          color: window.chartColors.border,
        },
        scaleLabel: {
          display: false,
        }
      }],
      yAxes: [{
        display: true,
        gridLines: {
          drawBorder: false,
          color: window.chartColors.border,
        },
        scaleLabel: {
          display: false,
        },
        ticks: {
          beginAtZero: true,
          userCallback: function (value, index, values) {
            return value.toLocaleString() + '%';
          }
        },
      }]
    }
  }
});

// ... Rest of your code for other charts










  /* Random number generator for demo purpose */
  var chart2_main = document.querySelector('#chart-2');
  var chart2Data = JSON.parse(chart2_main.getAttribute('data-chart2'));
var chart2name = JSON.parse(chart2_main.getAttribute('data-name2'));
 
  var ctx2 = chart2_main.getContext('2d');


    
var delayed = false; // Variable to track if animation has been delayed

var barChartConfig = new Chart(ctx2, {
  type: 'bar',
  data: {
    labels: chart2name,
    datasets: [{
      label: 'annulation',
      backgroundColor: "rgba(117,193,129,0.5)",
      hoverBackgroundColor: "rgba(117,193,129,1)",
      borderColor: "rgba(117,193,129,1)",
      borderRadius: 12,
      borderWidth: 2,
      data: chart2Data,
    }]
  },
  options: {
    responsive: true,
    legend: {
      position: 'bottom',
      align: 'end',
    },
    tooltips: {
      mode: 'index',
      intersect: false,
      titleMarginBottom: 10,
      bodySpacing: 10,
      xPadding: 16,
      yPadding: 16,
      borderColor: window.chartColors.border,
      borderWidth: 1,
      backgroundColor: '#fff',
      bodyFontColor: window.chartColors.text,
      titleFontColor: window.chartColors.text,
      callbacks: {
        label: function (tooltipItem, data) {
          return tooltipItem.value + '%';
        }
      },
    },
    scales: {
      xAxes: [{
        display: true,
        gridLines: {
          drawBorder: false,
          color: window.chartColors.border,
        },
      }],
      yAxes: [{
        display: true,
        gridLines: {
          drawBorder: false,
          color: window.chartColors.borders,
        },
        ticks: {
          beginAtZero: true,
          userCallback: function (value, index, values) {
            return value + '%';
          }
        },
      }]
    },
    animation: {
      onComplete: () => {
        delayed = true;
      },
      delay: (context) => {
        let delay = 0;
        if (context.type === 'data' && context.mode === 'default' && !delayed) {
          delay = context.dataIndex * 300 + context.datasetIndex * 100;
        }
        return delay;
      },
    },
  }
});














  var chart3_main = document.querySelector('#chart-3');
  var chart3Data = JSON.parse(chart3_main.getAttribute('data-chart3'));
var chart3name = JSON.parse(chart3_main.getAttribute('data-name3'));
 
    var ctx3 = chart3_main.getContext('2d');


    
var pieChartConfig = new Chart(ctx3, {
  type: 'doughnut',
  data: {
    labels: ['1 Star', '2 Stars', '3 Stars', '4 Stars', '5 Stars'],
    datasets: [{
        data: chart3Data,
        backgroundColor: [
          window.chartColors.green,
          window.chartColors.blue,
          window.chartColors.gray,
          window.chartColors.red,
    
          window.chartColors.purple,
          window.chartColors.orange,
          window.chartColors.pink,
          window.chartColors.cyan,
           window.chartColors.teal,
           window.chartColors.indigo,
           window.chartColors.brown,
           window.chartColors.magenta,
           window.chartColors.lime,
           window.chartColors.olive,
           window.chartColors.maroon,
           window.chartColors.navy,
           window.chartColors.salmon,
           window.chartColors.gold,
           window.chartColors.lavender,
        ],
  
        borderWidth: 1
    }]
},
 
  options: {
    responsive: true,
    legend: {
      display: true,
      position: 'bottom',
      align: 'center',
    },

    tooltips: {
      titleMarginBottom: 10,
      bodySpacing: 10,
      xPadding: 16,
      yPadding: 16,
      borderColor: window.chartColors.border,
      borderWidth: 1,
      backgroundColor: '#fff',
      bodyFontColor: window.chartColors.text,
      titleFontColor: window.chartColors.text,
      
      /* Display % in tooltip - https://stackoverflow.com/questions/37257034/chart-js-2-0-doughnut-tooltip-percentages */
      callbacks: {
                label: function(tooltipItem, data) {
          //get the concerned dataset
          var dataset = data.datasets[tooltipItem.datasetIndex];
          //calculate the total of this data set
          var total = dataset.data.reduce(function(previousValue, currentValue, currentIndex, array) {
          return previousValue + currentValue;
          });
          //get the current items value
          var currentValue = dataset.data[tooltipItem.index];
          //calculate the precentage based on the total and current item, also this does a rough rounding to give a whole number
          var percentage = Math.floor(((currentValue/total) * 100)+0.5);
          
          return percentage + "%";
          },
            },
      

    },
  }
});


















  var chart4_main = document.querySelector('#chart-4');
  var chart4Data = JSON.parse(chart4_main.getAttribute('data-chart4'));
var chart4name = JSON.parse(chart4_main.getAttribute('data-name4'));
 
  var ctx4 = chart4_main.getContext('2d');

  var lineChartConfig = new Chart(ctx4, {
    type: 'line',

    data: {
      labels:chart4name,

      datasets: [{
        label: 'Monthly income',
        backgroundColor: window.chartColors.purple,
        borderColor: window.chartColors.purple,
        data: chart4Data,
          pointStyle: 'circle',
      pointRadius: 10,
        pointHoverRadius: 15
      
      }]
    },
    options: {
      responsive: true,

      legend: {
        display: true,
        position: 'bottom',
        align: 'end',
      },

      tooltips: {
        mode: 'index',
        intersect: false,
        titleMarginBottom: 10,
        bodySpacing: 10,
        xPadding: 16,
        yPadding: 16,
        borderColor: window.chartColors.border,
        borderWidth: 1,
        backgroundColor: '#fff',
        bodyFontColor: window.chartColors.text,
        titleFontColor: window.chartColors.text,
        callbacks: {
          label: function (tooltipItem, data) {
            return tooltipItem.value + '%';
          }
        },
      },
      hover: {
        mode: 'nearest',
        intersect: true
      },
      scales: {
        xAxes: [{
          display: true,
          gridLines: {
            drawBorder: false,
            color: window.chartColors.border,
          },
          scaleLabel: {
            display: false,
          }
        }],
        yAxes: [{
          display: true,
          gridLines: {
            drawBorder: false,
            color: window.chartColors.border,
          },
          scaleLabel: {
            display: false,
          },
          ticks: {
            beginAtZero: true,
            userCallback: function (value, index, values) {
              return value.toLocaleString() + '%';
            }
          },
        }]
      }
    }
  });