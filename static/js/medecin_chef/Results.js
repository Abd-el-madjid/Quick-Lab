  function   open_donation_panel() {  
   

 $("#panel-1").css('transform' ,"scale(1)");
    $("#panel-1").removeClass('none');
    $("#tab-1").addClass('RRT__tab--first');
    $("#tab-1").addClass('RRT__tab--selected');
    close_test_panel();
  reset_search();
    console.log(" open_test_panel info open ") ;
};

function  close_donation_panel() {  
    $("#panel-1").css('transform' ,"scale(0)");
    $("#panel-1").addClass('none');
    $("#tab-1").removeClass('RRT__tab--first');
    $("#tab-1").removeClass('RRT__tab--selected');
    
    console.log(" close_test_panel info closd ") ;
};

function   open_test_panel() {  
    $("#panel-0").css('transform' ,"scale(1)");
    $("#panel-0").removeClass('none');
    $("#tab-0").addClass('RRT__tab--first');
    $("#tab-0").addClass('RRT__tab--selected');
    close_donation_panel();

reset_search();


    console.log(" open_donation_panel info open ") ;
};


function    close_test_panel() {  
    $("#panel-0").css('transform' ,"scale(0)");
    $("#panel-0").addClass('none');
    $("#tab-0").removeClass('RRT__tab--first');
    $("#tab-0").removeClass('RRT__tab--selected');
    
    console.log(" notification info closed ") ;
};

  function reset_search(){
    const rows = document.querySelectorAll("tbody tr");
    rows.forEach(row => {
      row.classList.remove('none');
    });
      document.querySelector("#date_search_bar_input").value = "";
      
      document.querySelector("#search_button").click;

    
 }
  
$(document).ready(function(){
    
   
    $(document).on('click', '#tab-1',  open_donation_panel );
    
    $(document).on('click', '#tab-0',  open_test_panel );
   
    }); 
    




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

function getCookie(name) {
    var cookieValue = null;
    if (document.cookie && document.cookie !== '') {
      var cookies = document.cookie.split(';');
      for (var i = 0; i < cookies.length; i++) {
        var cookie = cookies[i].trim();
        if (cookie.substring(0, name.length + 1) === (name + '=')) {
          cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
          break;
        }
      }
    }
    return cookieValue;
  }

function submitForm(id) {
    var message = document.getElementById("message-3b9a").value;

    // Create an AJAX request
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/medecin_chef/results/rapport/edit_rapport/" + id + "/", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.setRequestHeader("X-CSRFToken", getCookie("csrftoken")); // Include CSRF token in request headers
    xhr.onreadystatechange = function() {
      if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
          // Request completed successfully
          console.log(xhr.responseText);
          window.location.href = "/medecin_chef/results/rapport/" + id + "/";
        } else {
          // Request failed
          console.error(xhr.status);
        }
      }
    };
    
    // Set the form data to send
    var formData = "message=" + encodeURIComponent(message);
    
    // Send the AJAX request
    xhr.send(formData);
  }
  function submitForm1(id,id_res) {
    var message = document.getElementById("message-3b9a").value;

    // Create an AJAX request
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/medecin_chef/results/rapport/edit_rapport/" + id + "/", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.setRequestHeader("X-CSRFToken", getCookie("csrftoken")); // Include CSRF token in request headers
    xhr.onreadystatechange = function() {
      if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
          // Request completed successfully
          console.log(xhr.responseText);
          window.location.href = "/medecin_chef/results/rapport_donation/" + id_res + "/";
        } else {
          // Request failed
          console.error(xhr.status);
        }
      }
    };
    
    // Set the form data to send
    var formData = "message=" + encodeURIComponent(message);
    
    // Send the AJAX request
    xhr.send(formData);
  }

  function validrapport(id) {

    // Create an AJAX request
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/medecin_chef/results/rapport/" + id + "/", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.setRequestHeader("X-CSRFToken", getCookie("csrftoken")); // Include CSRF token in request headers
    xhr.onreadystatechange = function() {
      if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
          // Request completed successfully
          console.log(xhr.responseText);
          window.location.href = "/medecin_chef/results/";
        } else {
          // Request failed
          console.error(xhr.status);
        }
      }
    };

    xhr.send();
  }
  function validpoche(id,etat) {
    var params = "etat=" + encodeURIComponent(etat);
    // Create an AJAX request
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/medecin_chef/results/rapport_donation/" + id + "/", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.setRequestHeader("X-CSRFToken", getCookie("csrftoken")); // Include CSRF token in request headers
    xhr.onreadystatechange = function() {
      if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
          // Request completed successfully
          console.log(xhr.responseText);
          window.location.href = "/medecin_chef/results/";
        } else {
          // Request failed
          console.error(xhr.status);
        }
      }
    };

    xhr.send(params);
  }