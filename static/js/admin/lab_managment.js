








 function reset_search(){
    const rows = document.querySelectorAll(".row101");
    rows.forEach(row => {
      row.style.display = 'table-row';
    });
    document.querySelector("#search-orders").value = "";
    document.querySelector("#search-orders").click;
 }


const searchButton = document.querySelector("#search_button");
const searchInput = document.querySelector("#search-orders");

searchButton.addEventListener("click", () => {
  const searchValue = searchInput.value.trim().toLowerCase();
  const rows = document.querySelectorAll(".row101");

  rows.forEach(row => {
    const cells = row.querySelectorAll(".cell100");
    let isMatch = false;

    cells.forEach(cell => {
      if (cell.textContent.trim().toLowerCase().includes(searchValue)) {
        isMatch = true;
      }
    });

    if (isMatch) {
      row.style.display = 'table-row';
    } else {
      let rowText = row.textContent.trim().toLowerCase();
      if (rowText.includes(searchValue)) {
        row.style.display = 'table-row';
      } else {
        row.style.display = 'none';
      }
    }
  });
});

function   modifier_button_empl() {  
  $("#modifie_rdv_form").toggleClass('none');
 
 
  console.log(" date_search_bar_container info open ") ;
};

function   delet_button_empl() {  
  $("#delet_rdv_form").toggleClass('none');
 
 
  console.log(" date_search_bar_container info open ") ;
};

function lab_id(id) {
  
  var inputElements = document.querySelectorAll('input[name=dir_id]');
inputElements.forEach(function(element) {
  element.value = id;
});
}


function submit(event) {
  event.preventDefault(); // prevent the default behavior of the cancel button
  event.target.form.submit(); // submit the form element
}

function modifierlabo(event) {
  // Get the table row containing the clicked "Edit" button
  const row = event.target.closest(".row101");

  // Get the values of the cells in the row
  const id = row.querySelector("[data-title='id_lab']").innerText;
  const labName = row.querySelector("[data-title='lab name']").innerText;
  const dateFinText = row.querySelector("[data-title='abbonment']").innerText;
  const prix = row.querySelector("[data-title='price']").innerText;

  // Convert dateFinText to a proper Date format (e.g., "YYYY-MM-DD")
  let dateFin;
  if (dateFinText.includes("-")) {
    // Assuming the date is already in the "yyyy-MM-dd" format
    dateFin = dateFinText;
  } else {
    // Try to parse the date using different formats
    const parsedDate = new Date(dateFinText);
    if (!isNaN(parsedDate)) {
      // Successfully parsed the date, now format it as "yyyy-MM-dd"
      const year = parsedDate.getFullYear();
      const month = String(parsedDate.getMonth() + 1).padStart(2, "0");
      const day = String(parsedDate.getDate()).padStart(2, "0");
      dateFin = `${year}-${month}-${day}`;
    } else {
      // Unable to parse the date, set it as an empty string or handle the error accordingly
      dateFin = "";
      // Alternatively, you can log an error message or show an error notification
      console.error("Unable to parse the date:", dateFinText);
    }
  }

  // Set the input values in the "modifie_rdv_form" section
  const labIdInput = document.querySelector("input[name=lab_id]");
  const labNameInput = document.querySelector("input[name=lab_name]");
  const dateFinInput = document.querySelector("input[name=date_fin]");
  const prixInput = document.querySelector("input[name=prix]");

  // Set the values for the input fields
  labIdInput.value = id;
  labNameInput.value = labName;
  dateFinInput.value = dateFin;
  prixInput.value = prix;
}














    function toggleForm(id) {
    const form = $("#form_"+id);

        form.toggleClass('none');
        form.find('form')[0].reset();
      console.log("active button clicked");

  }
  










  

  function   open_block_panel() {  
   

 $("#panel-1").css('transform' ,"scale(1)");
    $("#panel-1").removeClass('none');
    $("#tab-1").addClass('RRT__tab--first');
    $("#tab-1").addClass('RRT__tab--selected');
    close_active_panel();
  reset_search();
    console.log(" open_active_panel info open ") ;
};

function  close_block_panel() {  
    $("#panel-1").css('transform' ,"scale(0)");
    $("#panel-1").addClass('none');
    $("#tab-1").removeClass('RRT__tab--first');
    $("#tab-1").removeClass('RRT__tab--selected');
    
    console.log(" close_active_panel info closd ") ;
};

function   open_active_panel() {  
    $("#panel-0").css('transform' ,"scale(1)");
    $("#panel-0").removeClass('none');
    $("#tab-0").addClass('RRT__tab--first');
    $("#tab-0").addClass('RRT__tab--selected');
    reset_search();
    close_block_panel();

 


    console.log(" open_block_panel info open ") ;
};


function    close_active_panel() {  
    $("#panel-0").css('transform' ,"scale(0)");
    $("#panel-0").addClass('none');
    $("#tab-0").removeClass('RRT__tab--first');
    $("#tab-0").removeClass('RRT__tab--selected');
    
    console.log(" notification info closed ") ;
};


  
$(document).ready(function(){
    
   
    $(document).on('click', '#tab-1',  open_block_panel );
    
    $(document).on('click', '#tab-0',  open_active_panel );
   
    }); 
    

function lab_name(name,id) {
  var labNameElement = document.getElementById("lab_name");
  var brancheIdInput = document.getElementById("branche_id");

// Set the value of the input field
  brancheIdInput.value = id;
  labNameElement.textContent = name;
}