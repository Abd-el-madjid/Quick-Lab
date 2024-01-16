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





function printButtonClick() {
 const button = document.querySelector('.print_head');
  
  if (button.innerText === 'print') {
    // Remove the "none" class from all div elements with class "col-00"
    const col00Elements = document.querySelectorAll('.col-00');
    col00Elements.forEach(element => {
      element.classList.remove('none');
    });

    // Set the CSS flex-basis property of all div elements with class "col-1" to 21%
    const col1Elements = document.querySelectorAll('.col-1');
    col1Elements.forEach(element => {
      element.style.flexBasis = '21%';
    });

    // Change the text from "print" to "ok"
    button.innerText = 'ok';

  } else if (button.innerText === 'ok') {
    // Get the values of the div elements with data-label="id" whose parent divs have checked checkboxes
    const idValues = [];
    document.querySelectorAll('input[type="checkbox"]:checked').forEach(checkbox => {
      const idDiv = checkbox.closest('.table-row').querySelector('div[data-label="id"]');
      if (idDiv) {
        idValues.push(idDiv.innerText.trim());
      }
    });

    // Store the values in the input element with the id "print_ids", separated by a "$"
    document.getElementById('print_ids').value = idValues.join('$');
  }
}




   function toggleForm() {
    const form_search = $("#form_search");
   
   
        form_search.toggleClass('none');
      console.log("add button clicked");
 
  }

function openPrintWindow(pdfUrl) {
  window.open(pdfUrl, '_blank', 'toolbar=yes,scrollbars=yes,resizable=yes,top=100,left=100,width=800,height=600');
}