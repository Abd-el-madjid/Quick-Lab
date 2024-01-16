function filterByDate() {
    // Get the input date from the search bar
    const inputDate = new Date(document.querySelector('#date_search_bar_input').value);

    // Loop through all the rendez-vous elements
    const rendezVousElements = document.querySelectorAll('tbody tr');
    rendezVousElements.forEach((rvElement) => {
        // Extract the date value from the rendez-vous element
        const rdvDateText = rvElement.querySelector('.collection_date').textContent.trim();
        const rdvDate = new Date(rdvDateText);

        // Compare the extracted date value with the input date
        if (rdvDate.toDateString() === inputDate.toDateString()) {
            // Keep the corresponding rendez-vous element visible
            rvElement.classList.remove('none');
        } else {
            // Hide the corresponding rendez-vous element
            rvElement.classList.add('none');
        }
    });

    // Check if there are no matching rows
    const matchingRows = document.querySelectorAll("tbody tr:not(.none)");
    const emptyResultatContainer = document.querySelector(".empty_resultat_container");
    const responsive_table = document.querySelector(".body_resultat");
    if (matchingRows.length === 0) {
        // Show the empty result container
        emptyResultatContainer.classList.remove("none");

        responsive_table.classList.add("none");
    } else {
        // Hide the empty result container
        emptyResultatContainer.classList.add("none");
        responsive_table.classList.remove("none");
    }
}

function send_date() {
    // Get the input date from the search bar
    const inputDateValue = document.querySelector('#date_search_bar_input').value;
    
    // Check if the input has a value
    if (inputDateValue.trim() !== '') {
        filterByDate();
    }
}


// Function to toggle the scanner form visibility
// function toggleForm() {
//     const formScanner = $("#form_scanner");
//     formScanner.toggleClass('none');
//     console.log("Scan button clicked");
    
//     // Check if the form is visible, then initialize the scanner
//     if (!formScanner.hasClass('none')) {
//       // Initialize the barcode scanner
//       Quagga.init({
//         inputStream: {
//           name: "Live",
//           type: "LiveStream",
//           target: document.querySelector("#scanner-container"),
//           constraints: {
//             facingMode: "environment" // Use the rear camera (if available)
//           }
//         },
//         decoder: {
//           readers: ["code_39_reader"] // Specify the desired barcode type (e.g., Code 39)
//         },
//       }, function (err) {
//         if (err) {
//           console.error(err);
//           return;
//         }
//         // Start the barcode scanner
//         Quagga.start();
//       });
  
//       // Handle the scanned barcode
//       Quagga.onDetected(function (result) {
//         var barcodeResult = document.querySelector("#barcode-result");
//         if (result && result.codeResult && result.codeResult.code) {
//           var barcode = result.codeResult.code;
//           barcodeResult.textContent = barcode;
//           // Perform any additional actions with the scanned barcode
//         }
//       });
//     } else {
//       // Stop the barcode scanner when the form is hidden
//       Quagga.stop();
//     }
//   }

function toggleForm() {
    const formScanner = $("#form_scanner");
    formScanner.toggleClass('none');
    console.log("Scan button clicked");
    
    // Check if the form is visible, then initialize the scanner
    if (!formScanner.hasClass('none')) {
      // Initialize the barcode scanner
      Quagga.init({
        inputStream: {
          name: "Live",
          type: "LiveStream",
          target: document.querySelector("#scanner-container"),
          constraints: {
            facingMode: "environment" // Use the rear camera (if available)
          }
        },
        decoder: {
          readers: ["code_39_reader"] // Specify the desired barcode type (e.g., Code 39)
        },
      }, function (err) {
        if (err) {
          console.error(err);
          return;
        }
        // Start the barcode scanner
        Quagga.start();
      });
  
      // Handle the scanned barcode
      Quagga.onDetected(function (result) {
        var barcodeResult = document.querySelector("#barcode-result");
        if (result && result.codeResult && result.codeResult.code) {
          var barcode = result.codeResult.code;
          barcodeResult.textContent = barcode;
          // Perform any additional actions with the scanned barcode
  
          // Stop the barcode scanner after scanning
          Quagga.stop();
          // Hide the scanner form
          formScanner.addClass('none');
          open_entrer_result(barcode);
        }
      });
    } else {
      // Stop the barcode scanner when the form is hidden
      Quagga.stop();
    }
  }
// function toggleForm() {
//   const formScanner = $("#form_scanner");
//   formScanner.toggleClass('none');
//   console.log("Scan button clicked");

//   // Check if the form is visible, then initialize the scanner
//   if (!formScanner.hasClass('none')) {
//     // Initialize the barcode scanner
//     Quagga.init({
//       inputStream: {
//         name: "Live",
//         type: "LiveStream",
//         target: document.querySelector("#scanner-container"),
//         constraints: {
//           facingMode: { exact: "environment" } // Use the rear camera (if available)
//         },
//         area: {
//           top: "0%",
//           right: "0%",
//           left: "0%",
//           bottom: "0%"
//         },
//         url: "http://105.106.197.40:8081/video" // Replace with the IP address and port of your camera stream
//       },
//       decoder: {
//         readers: ["code_39_reader"] // Specify the desired barcode type (e.g., Code 39)
//       },
//     }, function (err) {
//       if (err) {
//         console.error(err);
//         return;
//       }
//       // Start the barcode scanner
//       Quagga.start();
//     });

//     // Handle the scanned barcode
//     Quagga.onDetected(function (result) {
//       var barcodeResult = document.querySelector("#barcode-result");
//       if (result && result.codeResult && result.codeResult.code) {
//         var barcode = result.codeResult.code;
//         barcodeResult.textContent = barcode;
//         // Perform any additional actions with the scanned barcode

//         // Stop the barcode scanner after scanning
//         Quagga.stop();
//         // Hide the scanner form
//         formScanner.addClass('none');
//         open_entrer_result(barcode);
//       }
//     });
//   } else {
//     // Stop the barcode scanner when the form is hidden
//     Quagga.stop();
//   }
// }



  
  
  // function sendBarcodeToView(barcode) {
  //   const url = '/infirmier/results/fill_result/';
  //   const data = {
  //     barcode: barcode
  //   };
  
  //   // Get the CSRF token from the cookie
  //   const csrftoken = getCookie('csrftoken');
  
  //   // Send an AJAX POST request to the view
  //   const xhr = new XMLHttpRequest();
  //   xhr.open('POST', url, true);
  //   xhr.setRequestHeader('Content-Type', 'application/json');
  //   xhr.setRequestHeader('X-CSRFToken', csrftoken);
  
  //   xhr.onreadystatechange = function() {
  //     if (xhr.readyState === 4) {
  //       if (xhr.status === 200) {
  //         window.open
  //         // The view was successful, handle the response if needed
  //         console.log('Barcode sent to the view');
  //       } else {
  //         // Handle error or display a message
  //         console.error('An error occurred while sending the barcode');
  //       }
  //     }
  //   };
  
  //   xhr.send(JSON.stringify(data));
  // }
 
  function open_entrer_result(resultId) {
    // Process your barcode data here
  
    // Assuming you have the ID of the result you want to fill
  
    // Redirect to the fill_result view with the resultId
    resultId = resultId.slice(0, -1);
    window.location.href = '/infirmier/results/fill_result/' + resultId + '/';
  }  
  
  // Helper function to get the CSRF token from the cookie
  function getCookie(name) {
    const cookieValue = document.cookie.match('(^|;)\\s*' + name + '\\s*=\\s*([^;]+)');
    return cookieValue ? cookieValue.pop() : '';
  }