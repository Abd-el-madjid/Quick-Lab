

    function toggleForm() {
    const form_add = $("#form_add");
   
   
        form_add.toggleClass('none');
      console.log("add button clicked");
 
  }
  function   open_finish_panel() {  
   

 $("#panel-1").css('transform' ,"scale(1)");
    $("#panel-1").removeClass('none');
    $("#tab-1").addClass('RRT__tab--first');
    $("#tab-1").addClass('RRT__tab--selected');
    close_waiting_panel();
  reset_search();
    console.log(" open_waiting_panel info open ") ;
};

function  close_finish_panel() {  
    $("#panel-1").css('transform' ,"scale(0)");
    $("#panel-1").addClass('none');
    $("#tab-1").removeClass('RRT__tab--first');
    $("#tab-1").removeClass('RRT__tab--selected');
    
    console.log(" close_waiting_panel info closd ") ;
};

function   open_waiting_panel() {  
    $("#panel-0").css('transform' ,"scale(1)");
    $("#panel-0").removeClass('none');
    $("#tab-0").addClass('RRT__tab--first');
    $("#tab-0").addClass('RRT__tab--selected');
    close_finish_panel();

reset_search();


    console.log(" open_finish_panel info open ") ;
};


function    close_waiting_panel() {  
    $("#panel-0").css('transform' ,"scale(0)");
    $("#panel-0").addClass('none');
    $("#tab-0").removeClass('RRT__tab--first');
    $("#tab-0").removeClass('RRT__tab--selected');
    
    console.log(" notification info closed ") ;
};

  function reset_search(){
    const rows = document.querySelectorAll(".rendez-vous_container");
    rows.forEach(row => {
      row.classList.remove('none');
    });
      document.querySelector("#search-orders").value = "";
      
      document.querySelector("#search-orders").click;

      $('#select-filter1').val('All');
      
$('#select-filter2').val('All');
 }
  
$(document).ready(function(){
    
   
    $(document).on('click', '#tab-1',  open_finish_panel );
    
    $(document).on('click', '#tab-0',  open_waiting_panel );
   
    }); 
    



   











function filterByText() {
    // Get the input from the search bar
    const searchInput = document.querySelector('#search-orders').value.toLowerCase();

    // Loop through all the rendez-vous elements
    const rendezVousElements = document.querySelectorAll('.rendez-vous');

    rendezVousElements.forEach((rvElement) => {
        // Extract the lab name from the rendez-vous element
        const laboName = rvElement.querySelector('#name_patient').textContent.trim().toLowerCase();

        // Compare the lab name with the search input
        if (laboName.includes(searchInput)) {
            // If the lab name includes the search input, remove the 'none' class from the parent element
            rvElement.parentElement.classList.remove('none');
        } else {
            // If the lab name doesn't include the search input, add the 'none' class to the parent element
            rvElement.parentElement.classList.add('none');
        }
    });
}

function init() {
    document.querySelector('#search_button').addEventListener('click', filterByText);
    
// Add an event listener for the 'change' event on the select dropdown
    document.querySelector('#select-filter1').addEventListener('change', filterByType);
    
document.querySelector('#select-filter2').addEventListener('change', filterByPlace);

}

// Call the init function after the DOM has loaded
document.addEventListener('DOMContentLoaded', init);









function filterByType() {
    // Get the selected option from the dropdown
    const selectedType = document.querySelector('#select-filter1').value.toLowerCase();

    // Loop through all the rendez-vous elements
    const rendezVousElements = document.querySelectorAll('.rendez-vous');

    rendezVousElements.forEach((rvElement) => {
        // Extract the rdv type from the rendez-vous element
        const rdvType = rvElement.querySelector('.place').textContent.trim().toLowerCase();
        console.log()
        if (selectedType === 'all') {
            // If the selected option is 'all', remove the 'none' class from the parent element
            rvElement.parentElement.classList.remove('none');
        } else if (rdvType === selectedType) {
            // If the rdv type matches the selected option, remove the 'none' class from the parent element
            rvElement.parentElement.classList.remove('none');
        } else {
            // If the rdv type doesn't match the selected option, add the 'none' class to the parent element
            rvElement.parentElement.classList.add('none');
        }
    });
}






function filterByPlace() {
    // Get the selected option from the dropdown
    const selectedType = document.querySelector('#select-filter2').value.toLowerCase();

    // Loop through all the rendez-vous elements
    const rendezVousElements = document.querySelectorAll('.rendez-vous');

    rendezVousElements.forEach((rvElement) => {
        // Extract the rdv type from the rendez-vous element
        const rdvType = rvElement.querySelector('.rdv_type').textContent.trim().toLowerCase();

        if (selectedType === 'all') {
            // If the selected option is 'all', remove the 'none' class from the parent element
            rvElement.parentElement.classList.remove('none');
        } else if (rdvType === selectedType) {
            // If the rdv type matches the selected option, remove the 'none' class from the parent element
            rvElement.parentElement.classList.remove('none');
        } else {
            // If the rdv type doesn't match the selected option, add the 'none' class to the parent element
            rvElement.parentElement.classList.add('none');
        }
    });
}
function redirectToDetail(id) {
    // Redirect to detail page with the id
    window.location.href = "detaille/" + id;
}


// function printcodebare(rdvId, analyseCode, nurse_id) {
//     // Send an AJAX request to the view to generate the ID and barcode
//     var xhr = new XMLHttpRequest();
//     xhr.open("GET", `/infirmier/add_tube_analyse/?rdv_id=${rdvId}&nurse_id=${nurse_id}&analyse_code=${analyseCode}`, true);
//     xhr.responseType = "blob";
//     xhr.onreadystatechange = function() {
//         if (xhr.readyState === 4 && xhr.status === 200) {
//             var barcodeBlob = xhr.response;

//             // Create a URL for the barcode image blob
//             var barcodeUrl = URL.createObjectURL(barcodeBlob);

//             // Create a temporary hidden iframe and set its content to the barcode image
//             var iframe = document.createElement("iframe");
//             iframe.style.display = "none";
//             iframe.src = barcodeUrl;
//             document.body.appendChild(iframe);

//             // Wait for the barcode image to load in the iframe
//             iframe.onload = function() {
//                 // Print the iframe contents
//                 iframe.contentWindow.print();

//                 // Clean up the iframe
//                 setTimeout(function() {
//                     document.body.removeChild(iframe);
//                 }, 1000);  // Delay the cleanup to allow time for printing
//             };
//         }
//     };
//     xhr.send();
// }

function printcodebare(rdvId, analyse_Code, nurse_id) {
    // Send an AJAX request to the view to generate the ID and barcode
    var xhr = new XMLHttpRequest();
    xhr.open("GET", `/infirmier/add_tube_analyse/?rdv_id=${rdvId}&nurse_id=${nurse_id}&analyse_code=${analyse_Code}`, true);
    xhr.responseType = "blob";
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var barcodeBlob = xhr.response;

            // Create a URL for the barcode image blob
            var barcodeUrl = URL.createObjectURL(barcodeBlob);

            // Create an image element to load the barcode image
            var barcodeImage = new Image();
            barcodeImage.src = barcodeUrl;
            barcodeImage.style.display = "none";

            // Append the image to the document body
            document.body.appendChild(barcodeImage);

            // Wait for the image to load
            barcodeImage.onload = function() {
                // Create a temporary hidden iframe and set its content to the barcode image
                var iframe = document.createElement("iframe");
                iframe.style.display = "none";
                iframe.src = barcodeUrl;
                document.body.appendChild(iframe);

                // Wait for the barcode image to load in the iframe
                iframe.onload = function() {
                    // Print the iframe contents
                    iframe.contentWindow.print();

                    // Clean up the iframe and image element
                    setTimeout(function() {
                        document.body.removeChild(iframe);
                        document.body.removeChild(barcodeImage);
                    }, 1000);  // Delay the cleanup to allow time for printing
                };
            };
        }
    };
    xhr.send();
}
function removeListItem(linkElement) {
    var liElement = linkElement.closest('li');
    liElement.remove();
}


function done_analyse(rdvId) {
    const url = '/infirmier/done_analyse/';
    const data = {
        rdv_id: rdvId
    };

    // Get the CSRF token from the cookie
    const csrftoken = getCookie('csrftoken');

    // Send an AJAX POST request to the view
    const xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('X-CSRFToken', csrftoken);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                // The view was successful, redirect to liste_appointments
                window.location.href = '/infirmier/liste_appointments/';
            } else {
                // Handle error or display a message
                console.error('An error occurred.');
            }
        }
    };

    xhr.send(JSON.stringify(data));
}


// Helper function to get the CSRF token from the cookie
function getCookie(name) {
    const cookieValue = document.cookie.match('(^|;)\\s*' + name + '\\s*=\\s*([^;]+)');
    return cookieValue ? cookieValue.pop() : '';
}