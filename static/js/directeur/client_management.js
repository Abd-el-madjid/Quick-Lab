function client_id(event) {
    const id = event.target.closest('.row100').querySelector('[data-title="id"]').textContent.trim().replace(/\s+/g, '');
    const buttonValue = event.target.value.toLowerCase();
    const inputName = buttonValue === 'blocked' ? 'blocked_client_id' : 'active_client_id';
    document.querySelector(`input[name="${inputName}"]`).value = id;
  }
  
  function handleActionClick_toclient() {
    const buttons = document.querySelectorAll(".button_action");
    
    buttons.forEach(button => {
      const buttonValue = button.value.toLowerCase();
      
      if (buttonValue === "blocked") {
        button.addEventListener("click", form_toogle1);
      } else if (buttonValue === "active") {
        button.addEventListener("click", form_toogle2);
      }
    });
  }
  
  
  function form_toogle1() {
    $("#form_blocked").toggleClass('none');
    console.log("blocked button clicked");
  }
  
  function form_toogle2() {
    $("#form_active").toggleClass('none');
    console.log("active button clicked");
  }
  
  

  
  function selected_change_filter() {
    // Get the selected option
    const selectElement = document.getElementById('select-filter');
    const selectedOption = selectElement.value.toLowerCase();
  
    // Get a reference to all the rows in the table
    const rows = document.querySelectorAll('.table100 .row101');
  
    // Iterate through all the rows and hide/show them based on the selected option
    rows.forEach(row => {
      const actionCell = row.querySelector('.button_action_cell');
      const actionValue = actionCell.querySelector('input').value.toLowerCase();
  
      if (selectedOption === 'all') {
        row.style.display = 'table-row';
      } else if(actionValue === selectedOption) {
          row.style.display = 'table-row';
      }else {
          row.style.display = 'none';
      }
    });
  }
  