function init(){
    get_form();
 
    

    getWorkTime();




// Get all the checkbox elements
const checkboxes = document.querySelectorAll('input[type="checkbox"]');

// Loop through each checkbox
checkboxes.forEach((checkbox) => {
  // Add a click event listener to each checkbox
  checkbox.addEventListener('click', () => {
    // Get the parent day_field div element of the clicked checkbox
    const dayField = checkbox.parentElement.parentElement;
    // Get the time_field div element inside the parent day_field div element
    const timeField = dayField.querySelector('.time_field_container');
    // Toggle the 'none' class of the time_field div element
    timeField.classList.toggle('none');
  });
});







   
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

  function toggleForm() {
    const formdelete = $("#form_delete");
  const formedit = $("#form_edit");
   
  const formedit_lab = $("#form_edit_laboratory");
    
    if (!formdelete.hasClass('none')) {
        formdelete.addClass('none');
        formdelete.find('form')[0].reset();
      console.log("active button clicked");
    } else if (!formedit.hasClass('none')) {
        formedit.addClass('none');
        formedit.find('form')[0].reset();
      console.log("blocked button clicked");
    }
    else if (!formedit_lab.hasClass('none')) {
      formedit_lab.addClass('none');
      formedit_lab.find('form')[0].reset();
    console.log("blocked button clicked");
  }
  }
  





  function getWorkTime() {
    // sélectionner tous les éléments de case à cocher
    const checkboxes = document.querySelectorAll('.day_field input[type="checkbox"]');
  
    // sélectionner l'élément d'entrée pour les heures de travail
    const workTimeInput = document.querySelector('#days_work_time');
  
    // initialiser une variable pour stocker les informations des heures de travail
    let workTime = '';
  
    // boucle à travers chaque case à cocher
    checkboxes.forEach(function(checkbox) {
      // vérifier si la case à cocher est cochée
      if (checkbox.checked) {
        // récupérer la valeur de la case à cocher (jour de la semaine)
        const dayOfWeek = checkbox.value;
  
        // récupérer les heures de début et de fin pour ce jour de la semaine
        const timeFields = checkbox.closest('.day_field').querySelectorAll('input[type="time"]');
        const startTime = timeFields[0].value;
        const endTime = timeFields[1].value;
  
        // ajouter les informations des heures de travail pour ce jour de la semaine à la variable workTime
        workTime += `${dayOfWeek}>${startTime}>${endTime}$`;
      }
    });
  
    // mettre les informations des heures de travail dans l'élément d'entrée
    workTimeInput.value = workTime;
  }
  


  function branche_id(event) {
    const id = event.target.closest('.row101').querySelector('[data-title="id"]').textContent.trim().replace(/\s+/g, '');
    const buttonValue = event.target.textContent.toLowerCase();
    const inputName = buttonValue === 'delete' ? 'branche_id_delet' : 'branche_id_edit';
    document.querySelector(`input[name="${inputName}"]`).value = id;
}


function branche_info(event){
  const row = event.target.closest('.row101');
  const branche_Name = row.querySelector('[data-title="branche name"]').textContent.trim().replace(/\s+/g, '');
  const new_name = document.querySelector('input[name="new_name"]');
 
  new_name.value = branche_Name;

}
function lab_info(){
 
    const formedit_lab = $("#form_edit_laboratory");
      formedit_lab.removeClass('none');
      formedit_lab.find('form')[0].reset();
    console.log("blocked button clicked");
  
  
  const lab_Name = document.querySelector('.lab_name').textContent.trim();
  const appointments_cap = document.querySelector('.appointments_cap').textContent.trim();
  const lab_id = document.querySelector('.lab_id').textContent.trim();

  const lab_id_edit = document.querySelector('input[name="lab_id_edit"]');
  
  const appointment_per_hour = document.querySelector('input[name="appointment_per_hour"]');
  
  const new_name_laboratory = document.querySelector('input[name="new_name_laboratory"]');

 
  lab_id_edit.value = lab_id;
  new_name_laboratory.value = lab_Name;
  appointment_per_hour.value = appointments_cap;

}


