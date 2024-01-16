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

function deleteEmployee(event) {
  
  const id = event.target.closest('.row100').querySelector('[data-title="id"]').textContent.trim().replace(/\s+/g, '');
  document.querySelector("#employe_id").value = id;
}


function submit(event) {
  event.preventDefault(); // prevent the default behavior of the cancel button
  event.target.form.submit(); // submit the form element
}

function modifierEmployee(event) {
  // Get the table row containing the clicked "Edit" button
  const row = event.target.closest(".row101");

  // Get the values of the cells in the row
  const id = row.querySelector("[data-title=id]").innerText;
  const fullName = row.querySelector("[data-title='Full Name']").innerText;
  const password = row.querySelector("[data-title=Password]").innerText;
  const username = row.querySelector("[data-title=Username]").innerText;
  const type = row.querySelector("[data-title=type]").innerText;
  
  const email = row.querySelector("[data-title=Email]").innerText;
  const phone = row.querySelector("[data-title='Phone Number']").innerText;
  const dobString = row.querySelector("[data-title='Date of birth']").innerText;
  
  const gender = row.querySelector("[data-title=Gender]").innerText;
  // Parse the date string into a Date object
  const dob = new Date(dobString);
  
  // Format the date string in the desired format (YYYY-MM-DD)
  const year = dob.getFullYear();
  const month = dob.getMonth() + 1;
  const day = dob.getDate();
  const formattedDob = `${year}-${month < 10 ? '0' : ''}${month}-${day < 10 ? '0' : ''}${day}`;
  

  // Set the input values in the "modifie_rdv_form" section
  document.querySelector("input[name=id]").value = id;
  document.querySelector("input[name=Full_Name]").value = fullName;
  document.querySelector("input[name=Password]").value = password;
  document.querySelector("input[name=Username]").value = username;
  
  document.querySelector("select[name=gender]").value = gender;

  document.querySelector("input[name=Email]").value = email;
  document.querySelector("select[name=type]").value = type;
  document.querySelector("input[name=Phone_Number]").value = phone;
  document.querySelector("input[name=date_of_birth]").value = formattedDob;
}
