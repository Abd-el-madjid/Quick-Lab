function filterByDate() {
    // Get the input date from the search bar
    const inputDate = new Date(document.querySelector('#date_search_bar_input').value);

  
    // Loop through all the rendez-vous elements
    const rendezVousElements = document.querySelectorAll('.table-row');
    rendezVousElements.forEach((rvElement) => {
      // Extract the date value from the rendez-vous element
      const rdvDateText = rvElement.querySelector('.collection_date').textContent.trim();
      const rdvDate = new Date(rdvDateText);
  
      // Compare the extracted date value with the input date
      if (rdvDate.toDateString() === inputDate.toDateString()) {
        // Keep the corresponding rendez-vous element visible
        rvElement.parentElement.classList.remove('none');
      } else {
        // Hide the corresponding rendez-vous element
        rvElement.parentElement.classList.add('none');
      }
    });

      // Check if there are no matching rows
  const matchingRows = document.querySelectorAll(".table-row_container:not(.none)");
  const emptyResultatContainer = document.querySelector(".empty_resultat_container");
  const responsive_table = document.querySelector("#responsive-table");
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


  function openPrintWindow(pdfUrl) {
    window.open(pdfUrl, '_blank', 'toolbar=yes,scrollbars=yes,resizable=yes,top=100,left=100,width=800,height=600');
  }