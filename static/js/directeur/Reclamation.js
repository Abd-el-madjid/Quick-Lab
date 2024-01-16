function init(){
    get_form();
    


const searchButton = document.querySelector("#search_button");
const searchInput = document.querySelector("#search-orders");

searchButton.addEventListener("click", () => {
  const searchValue = searchInput.value.trim().toLowerCase();
  const rows = document.querySelectorAll(".table-container tbody tr");

  rows.forEach(row => {
    const cells = row.querySelectorAll("td");
    let isMatch = false;

    cells.forEach(cell => {
      if (cell.textContent.trim().toLowerCase().indexOf(searchValue) !== -1) {
        isMatch = true;
      }
    });

    if (isMatch) {
      row.style.display = "table-row";
    } else {
      row.style.display = "none";
    }
  });
});

    
    
}




function toggleForm() {
    const formdelete = $("#form_delete");
  const formreply = $("#form_reply");
  const formedit = $("#form_edit");
   
   
    
    if (!formdelete.hasClass('none')) {
        formdelete.addClass('none');
        formdelete.find('form')[0].reset();
      console.log("active button clicked");
    } else if (!formreply.hasClass('none')) {
        formreply.addClass('none');
        formreply.find('form')[0].reset();
      console.log("blocked button clicked");
    }
    else if (!formedit.hasClass('none')) {
        formedit.addClass('none');
        formedit.find('form')[0].reset();
      console.log("blocked button clicked");
    }
  }


  function get_form() {
    const items = document.querySelectorAll(".dropdown-item");
  
    items.forEach((item) => {
      item.addEventListener("click", (event) => {
        // Get the text content of the clicked item
        const itemText = event.target.textContent.trim().toLowerCase();
  
        // Hide all forms
        document.querySelectorAll(".form").forEach((form) => {
          form.classList.add("none");
        });
  
        // Show the appropriate form based on the clicked item
        if (itemText === "reply") {
          $("#form_reply").removeClass("none");
        } else if (itemText === "delete") {
          $("#form_delete").removeClass("none");
        }else if(itemText === "edit"){
            $("#form_edit").removeClass("none");
        }
  
      
      });
    });
  }


  function reclamation_id(event) {
    const id = event.target.closest('.table-row_container').querySelector('.id').textContent.trim().replace(/\s+/g, '');
    const buttonValue = event.target.textContent.toLowerCase();
    let inputName, inputValue;
    
    if (buttonValue === 'delete') {
      inputName = 'reclamation_id_delet';
      inputValue = id;
    } else if (buttonValue === 'reply') {
      inputName = 'reclamation_id_reply';
      inputValue = id;
    } else if (buttonValue === 'edit') {
      inputName = 'reclamation_id_edit';
      inputValue = id;
    }
    
    document.querySelector(`input[name="${inputName}"]`).value = inputValue;
  }
  



function reclamation_info(event){
    const row = event.target.closest('.table-row_container');


    const reclamation_text = row.querySelector('.text').textContent.trim();
    const reclamation_text_form = document.querySelector('.reclamation_text');
   
    reclamation_text_form.textContent = reclamation_text;
  

    const reclamation_object = row.querySelector('.object').textContent.trim();
    const reclamation_object_form = document.querySelector('.reclamation_object');
   
    reclamation_object_form.textContent = reclamation_object;

    
  
  }
  function reclamation_reply(event){
    const row = event.target.closest('.table-row_container');
    const reclamation_reponse = row.querySelector('.answer').textContent.trim();
    const reclamation_reponse_form = document.querySelector('#message-3b9ab');
   
    reclamation_reponse_form.value = reclamation_reponse;

    const reclamation_text = row.querySelector('.text').textContent.trim();
    const reclamation_text_form = document.querySelector('.reclamation_text2');
   
    reclamation_text_form.textContent = reclamation_text;
  

    const reclamation_object = row.querySelector('.object').textContent.trim();
    const reclamation_object_form = document.querySelector('.reclamation_object2');
   
    reclamation_object_form.textContent = reclamation_object;

  }

function reset_search() {
  const rows = document.querySelectorAll(".table-container tbody tr");
  rows.forEach(row => {
    row.style.display = "table-row";
  });
  document.querySelector("#search-orders").value = "";
  document.querySelector("#search_button").click();
}





      function handleDropdown() {
        const button = event.target;
        const menu = button.parentNode.querySelector("#dropdown-menu_container");
      
        // toggle the show class to show/hide the dropdown
        menu.classList.toggle("show");
      
        // hide all other dropdowns
        const menus = document.querySelectorAll("#dropdown-menu_container");
        menus.forEach((dropdown) => {
          if (dropdown !== menu) {
            dropdown.classList.remove("show");
          }
        });
      
        // hide dropdown when clicking on a dropdown-item
        const dropdownItems = menu.querySelectorAll(".dropdown-item");
        dropdownItems.forEach((item) => {
          item.addEventListener("click", hideDropdown);
        });
      }
      
      function hideDropdown() {
        const menu = this.closest("#dropdown-menu_container");
        menu.classList.remove("show");
      }
      





















  function   open_reply_panel() {  
   

 $("#panel-1").css('transform' ,"scale(1)");
    $("#panel-1").removeClass('none');
    $("#tab-1").addClass('RRT__tab--first');
    $("#tab-1").addClass('RRT__tab--selected');
    close_reclamation_panel();
  reset_search();
    console.log(" open_reclamation_panel info open ") ;
};

function  close_reply_panel() {  
    $("#panel-1").css('transform' ,"scale(0)");
    $("#panel-1").addClass('none');
    $("#tab-1").removeClass('RRT__tab--first');
    $("#tab-1").removeClass('RRT__tab--selected');
    
    console.log(" close_reclamation_panel info closd ") ;
};

function   open_reclamation_panel() {  
    $("#panel-0").css('transform' ,"scale(1)");
    $("#panel-0").removeClass('none');
    $("#tab-0").addClass('RRT__tab--first');
    $("#tab-0").addClass('RRT__tab--selected');
    close_reply_panel();

 reset_search();


    console.log(" open_reply_panel info open ") ;
};


function    close_reclamation_panel() {  
    $("#panel-0").css('transform' ,"scale(0)");
    $("#panel-0").addClass('none');
    $("#tab-0").removeClass('RRT__tab--first');
    $("#tab-0").removeClass('RRT__tab--selected');
    
    console.log(" notification info closed ") ;
};


  
$(document).ready(function(){
    
   
    $(document).on('click', '#tab-1',  open_reply_panel );
    
    $(document).on('click', '#tab-0',  open_reclamation_panel );
   
    }); 
    