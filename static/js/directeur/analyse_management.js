function init(){
    get_form();
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
        if (itemText === "edit") {
          $("#form_edit").removeClass("none");
        } else if (itemText === "delete") {
          $("#form_delete").removeClass("none");
        }
  
      
      });
    });
  }



  function analyse_id(event) {
    const id = event.target.closest('.row101').querySelector('[data-title="id"]').textContent.trim().replace(/\s+/g, '');
    const buttonValue = event.target.textContent.toLowerCase();
    const inputName = buttonValue === 'delete' ? 'analyse_id_delet' : 'analyse_id_edit';
    document.querySelector(`input[name="${inputName}"]`).value = id;
}




 
  

  function toggleForm() {
    const formdelete = $("#form_delete");
  const formedit = $("#form_edit");
   
   
    
    if (!formdelete.hasClass('none')) {
        formdelete.addClass('none');
      console.log("active button clicked");
    } else if (!formedit.hasClass('none')) {
        formedit.addClass('none');
      console.log("blocked button clicked");
    }
  }
  
  

  function analyse_info(event) {
    const row = event.target.closest('.row101');
    const analyseName = row.querySelector('[data-title="analyse name"]').textContent.trim().replace(/\s+/g, '');
    const price = row.querySelector('[data-title="price"]').textContent.trim().replace(/\s+/g, '');
    const analyseNameTag = document.querySelector('#analyse_name');
    const priceInput = document.querySelector('input[name="new_price"]');
    analyseNameTag.textContent = analyseName;
    priceInput.value = price;
    
  }
  
  