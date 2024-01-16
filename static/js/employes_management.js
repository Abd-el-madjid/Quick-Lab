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
  console.log("i m here")
 
 
  console.log(" date_search_bar_container info open ") ;
};

function   delet_button_empl(id) {  
  $("#delet_rdv_form").toggleClass('none');
  $('input[name=employe_id]').val(id);
  
  console.log("i work")
  console.log(" date_search_bar_container info open ") ;
};

// function deleteEmployee(event) {
//   const id = event.target.closest('.row100').querySelector('[data-title="id"]').textContent;
//   document.querySelector("#employe_id").value = id;
// }

function submit(event) {
  event.preventDefault(); // prevent the default behavior of the cancel button
  event.target.form.submit(); // submit the form element
}

function modifierEmployee(event) {
  // Get the table row containing the clicked "Edit" button
  const row = event.target.closest(".row101");

  // Get the values of the cells in the row
  // const id = row.querySelector("[data-title=id_prs]").innerText;
  // const fullName = row.querySelector("[data-title='Full Name']").innerText;
  // const type = row.querySelector("[data-title=type]").innerText;
  
  // const email = row.querySelector("[data-title=Email]").innerText;
  // const phone = row.querySelector("[data-title='Phone Number']").innerText;
  // const dobString = row.querySelector("[data-title='Date of birth']").innerText;
  // const place_birth = row.querySelector("[data-title='place of birth']").innerText;
  // const barnche = row.querySelector("[data-title='branch']").innerText;
  // const id_branch = row.querySelector("[data-title='id_branch']").innerText;
  // const gender = row.querySelector("[data-title=Gender]").innerText;
  // // Parse the date string into a Date object
  // const dob = new Date(dobString);
  
  // // Format the date string in the desired format (YYYY-MM-DD)
  // const year = dob.getFullYear();
  // const month = dob.getMonth() + 1;
  // const day = dob.getDate();
  // const formattedDob = `${year}-${month < 10 ? '0' : ''}${month}-${day < 10 ? '0' : ''}${day}`;
  

  // // Set the input values in the "modifie_rdv_form" section
  // document.querySelector("input[name=NIN]").value = id;
  // document.querySelector("input[name=Full_Name]").value = fullName;
  // document.querySelector("input[name=Password]").value = password;
  // document.querySelector("input[name=Username]").value = username;
  
  // document.querySelector("select[name=gender]").value = gender;

  // document.querySelector("input[name=email]").value = email;
  // document.querySelector("select[name=type]").value = type;
  // document.querySelector("input[name=Phone_Number]").value = phone;
  // document.querySelector("input[name=date_of_birth]").value = formattedDob;
}

function modifierEmployee(id) {
  $.ajax({
      url: "/directeur/gestionemp/getinfo/0".replace('0', id),
      type: 'GET',
      dataType: 'json',
      success: function(response) {
          // update the page with the response
          $('input[name=id]').val(response.emp);
          $('input[name=fname]').val(response.emplye.nom);
          $('input[name=lname]').val(response.emplye.prenom);
          $('input[name=email]').val(response.emplye.email);
          $('input[name=Phone_Number]').val(response.emplye.num_telephone);
          $('input[name=date_of_birth]').val(response.emplye.date_naissance);
          $('input[name=placebirth]').val(response.emplye.lieu_naissance);
          $('input[name=NIN]').val(id);
          $('option[name=type]').val(response.type).text(response.type);
          $('option[name=branch]').val(response.barnche_id).text(response.branche_name);
          $('option[name=gender]').val(response.emplye.sex).text(response.emplye.sex);
          // show the modal or form to edit the employee
          $('#editEmployeeModal').modal('show');
      },
      error: function(xhr, status, error) {
          // handle the error
          console.log(error);
      }
  });
}











function selected_change_filter() {
  // Get the selected option
  const selectElement = document.getElementById('select-filter');
  const selectedOption = selectElement.value.toLowerCase();

  // Get a reference to all the rows in the table
  const rows = document.querySelectorAll('.table100 .row101');

  // Iterate through all the rows and hide/show them based on the selected option
  rows.forEach(row => {
    const typeCell = row.querySelector('.cell100[data-title="type"]');
    const actionValue = typeCell.innerText.toLowerCase().trim();

    if (selectedOption === 'all worker') {
      row.style.display = 'table-row';
    } else if (actionValue === selectedOption) {
      row.style.display = 'table-row';
    } else {
      row.style.display = 'none';
    }
  });
}
