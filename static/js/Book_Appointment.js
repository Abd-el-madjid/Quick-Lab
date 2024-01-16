/* Save the checkbox values to localStorage
function saveCheckboxValues() {
  const checkboxes = document.querySelectorAll('input[type="checkbox"]');
  const values = [];
  for (let i = 0; i < checkboxes.length; i++) {
    if (checkboxes[i].checked) {
      values.push(checkboxes[i].value);
    }
  }
  localStorage.setItem('checkboxValues', JSON.stringify(values));
}

// Load the checkbox values from localStorage
function loadCheckboxValues() {
  const values = JSON.parse(localStorage.getItem('checkboxValues'));
  if (values) {
    const checkboxes = document.querySelectorAll('input[type="checkbox"]');
    for (let i = 0; i < checkboxes.length; i++) {
      if (values.includes(checkboxes[i].value)) {
        checkboxes[i].checked = true;
      }
    }
  }
}

// Call the saveCheckboxValues function when the form is submitted
const form = document.querySelector('#filtre_form');
form.addEventListener('submit', saveCheckboxValues);

// Call the loadCheckboxValues function when the page is loaded
window.addEventListener('load', loadCheckboxValues);

*/

function init(){


  appointment_time_slot();
  
  mobiscroll.setOptions({
    locale: mobiscroll.localeAr,
    theme: 'ios',
    themeVariant: 'light'
  });
  
  mobiscroll.select('#type_analyse_selected-list', {
    inputElement: document.getElementById('type_analyse_selected-input')
  });
  
  mobiscroll.select('#Disponibilités-list', {
    inputElement: document.getElementById('Disponibilités-input')
  });
  mobiscroll.select('#Moyens_de_paiement-list', {
    inputElement: document.getElementById('Moyens_de_paiement-input')
  });
  
  
  mobiscroll.select('#purpose-list', {
    inputElement: document.getElementById('purpose-input')
  });
  
  
  
  
  }
  
  
  
  
  
    
  // Get all the checkboxes with the name "purpose"
  const checkboxes = document.getElementsByName("purpose");
  
  // Add an event listener to each checkbox
  checkboxes.forEach(function(checkbox) {
    checkbox.addEventListener("click", function() {
      // Uncheck all checkboxes except the one that was clicked
      checkboxes.forEach(function(otherCheckbox) {
        if (otherCheckbox !== checkbox) {
          otherCheckbox.checked = false;
        }
      });
    });
  });
  
  
  function type_analyse_selected_list_submit() {
    const selectedCheckboxesInput = document.querySelector('#selected_input_analyse');
    const selectedInput = document.querySelector('#type_analyse');
    if (selectedCheckboxesInput.value != '') {
      selectedInput.value = selectedCheckboxesInput.value;
      go_to_etape3();
    } else {
      const alertDiv = document.createElement('div');
      alertDiv.className = 'custom-alert alert-error';
      alertDiv.innerHTML = '<div class="icon__wrapper"><span class="material-symbols-outlined">error</span></div> Please select analyse for your visite by .';
      document.body.appendChild(alertDiv);
  
      setTimeout(function () {
        alertDiv.remove();
      }, 3000);
    }
  }
  
  
  function   purpose_submit(){
    const checkboxes =document.querySelector('#purpose-input').value;
  
    const selectedCheckboxesInput = document.querySelector('#purpose_filtre');
    
    selectedCheckboxesInput.value = checkboxes;
  }
  function   moyens_de_paiement_submit(){
    
    const checkboxes =document.querySelector('#Moyens_de_paiement-input').value;
  
      const selectedCheckboxesInput = document.querySelector('#methode_payment_filtre');
      
      selectedCheckboxesInput.value = checkboxes;
    }
   
    function   Disponibilités_submit(){
      const checkboxes = document.querySelector('#Disponibilités-input').value;
  
      const selectedCheckboxesInput = document.querySelector('#disponibilite_filtre');
      selectedCheckboxesInput.value = checkboxes;
    }
    function   type_analyse_selected_submit(){
      const checkboxes = document.querySelector('#type_analyse_selected-input').value;
  
      const selectedCheckboxesInput = document.querySelector('#type_analyse_filtre');
      selectedCheckboxesInput.value = checkboxes;
  
  
      const selectedInput = document.querySelector('#type_analyse');
      selectedInput.value = checkboxes;
    }
    
    function filtre() {
      // Create a new form element
      var form = document.createElement('form');
      form.method = 'POST';
      form.action = '/patient/book_appointment/'; // Update the action URL
      
      // Create an input field for typeAnalyseSelected
      var typeAnalyseSelected = Array.from(document.querySelectorAll('#type_analyse_selected-list option:checked')).map(option => option.value).join(',');
      var typeAnalyseInput = document.createElement('input');
      typeAnalyseInput.type = 'hidden';
      typeAnalyseInput.name = 'typeAnalyseSelected';
      typeAnalyseInput.value = typeAnalyseSelected;
      form.appendChild(typeAnalyseInput);
      
      // Get the CSRF token from the cookie
      var csrftoken = getCookie('csrftoken');
      
      // Create an input field for the CSRF token
      var csrfTokenInput = document.createElement('input');
      csrfTokenInput.type = 'hidden';
      csrfTokenInput.name = 'csrfmiddlewaretoken';
      csrfTokenInput.value = csrftoken;
      form.appendChild(csrfTokenInput);
      
      // Append the form to the document body
      document.body.appendChild(form);
      
      // Submit the form
      form.submit();
    }
    
    function   payment_submit_showing(){
      get_payment();
      let payment_submit = document.getElementById("payment_submit");
      let submit_information_rdv = document.getElementById("submit_information_rdv");
      // submit_information_rdv.click();
      // payment_submit.click();
      
      const formData = new FormData(document.getElementById('myForm'));

       // Send the data to the server using AJAX
      const xhr = new XMLHttpRequest();
      xhr.open("POST", "/patient/book_appointment/");
      xhr.setRequestHeader('X-CSRFToken', getCookie('csrftoken'));
      xhr.onload = function() {
          if (xhr.status === 200) {
            const response = JSON.parse(xhr.responseText);
            const rdv_id = response.rdv_id;
            const file_path = response.file_path;
            window.open("http://127.0.0.1:8000/" + file_path, '_blank', 'toolbar=yes,scrollbars=yes,resizable=yes,top=100,left=100,width=800,height=600');
            window.location.href = "/patient/detaille_appointments/" +  rdv_id + "/";
          } else {
            const alertDiv = document.createElement('div');
            alertDiv.className = 'custom-alert alert-error';
            alertDiv.innerHTML = '<div class="icon__wrapper"><span class="material-symbols-outlined">error</span></div> please make sure the information of your carte bancaire are correct.';
            document.body.appendChild(alertDiv);
          
            setTimeout(function() {
              alertDiv.remove();
            }, 3000);
          }
      };
      xhr.send(formData);
      
    }
    function getCookie(name) {
      const value = `; ${document.cookie}`;
      const parts = value.split(`; ${name}=`);
      if (parts.length === 2) return parts.pop().split(';').shift();
  }
    
  
   
  
    function get_payment(){
      let code_s= document.getElementById("code_s").value;
      let num_carte= document.getElementById("num_carte").value;
      let date_exp= document.getElementById("date_exp").value;
      
      document.getElementById("code_s_b").value = code_s;
      document.getElementById("num_carte_b").value = num_carte;
      document.getElementById("date_exp_b").value = date_exp;
    
    }
    function back_to_etape1() {  
      $("#etape2").css('transform' ,"scale(0)");
      $("#etape2").addClass('none');
      $("#etape1").css('transform' ,"scale(1)");
      $("#etape1").removeClass('none');
      $("#Disponibilités-list").removeClass('none');
      $("#type_analyse_selected-list").removeClass('none');
      $("#Moyens_de_paiement-list").removeClass('none');
      $("#Disponibilités-list").addClass('none');
      $("#type_analyse_selected-list").addClass('none');
      $("#Moyens_de_paiement-list").addClass('none');
      
      console.log(" form info closed ") ;
    };
    function back_to_etape2() {  
      $("#type-rdv").css('transform' ,"scale(0)");
      $("#type-rdv").addClass('none');
      $("#etape2").css('transform' ,"scale(1)");
      $("#etape2").removeClass('none');
      
      console.log(" form info closed ") ;
    };
    function back_from_etape3() {  
      $("#etape3").css('transform', 'scale(0)');
      $("#etape3").addClass('none');
      var rdv_purpose = $("#rdv_purpose").val();
      if (rdv_purpose === "blood test") {
        $(".type-analyse").css('transform', 'scale(1)');
        $(".type-analyse").removeClass('none');
        console.log('Showing etape5 for blood test');
      } else if (rdv_purpose === "blood donation") {
        $("#type-rdv").css('transform', 'scale(1)');
        $("#type-rdv").removeClass('none');
        console.log('Showing etape6 for blood donation');
      }
      
      console.log(" form info closed ") ;
    };
  

    function back_to_etape_type_rdv() {  

      $(".type-analyse").css('transform' ,"scale(0)");
      $(".type-analyse").addClass('none');
      var rdv_type = $("#rdv_type").val();
      if (rdv_type === "in the laboratory") {
        
        $("#type-rdv").css('transform' ,"scale(1)");
    $("#type-rdv").removeClass('none');
        console.log('Showing etape5 for blood test');
      } else if (rdv_type === "at home") {
        $("#etape2").css('transform', 'scale(1)');
        $("#etape2").removeClass('none');
        console.log('Showing etape6 for blood donation');
      }

      
      console.log(" form info closed ") ;
    };
    function back_to_etape4() {  
      $("#etape5").css('transform' ,"scale(0)");
      $("#etape5").addClass('none');
      $("#etape3").css('transform' ,"scale(1)");
      $("#etape3").removeClass('none');
      
      console.log(" form info closed ") ;
    };
  
  
  
  
  
  
  
    function go_to_etape2(id,logo,name) {  
      // Update elements with class name "progression_info_general_img"
        

// Iterate over the elements and update their content

      const rdvDate = document.getElementById('rdv_date');
      const rdvTime = document.getElementById('rdv_time');
      const id_brch = document.getElementById('id_branch');
      
    
      if (rdvDate.value && rdvTime.value) {
        const imgElements = document.getElementsByClassName("progression_info_general_img");
        for (let i = 0; i < imgElements.length; i++) {
          const element = imgElements[i];
          const initialsElement = element.querySelector(".initials");
          initialsElement.textContent = logo; // Update the content as desired
        }

        // Update elements with class name "progression_info_general_side_name"
        const nameElements = document.querySelectorAll('.progression_info_general_side_name');
        nameElements.forEach(element => {
          element.textContent = name; // Update the content as desired
        });
        $("#etape1").css('transform' ,"scale(0)");
        $("#etape1").addClass('none');
        $("#etape2").css('transform' ,"scale(1)");
        $("#etape2").removeClass('none');
        const checkboxList = document.querySelector('.checkbox-type_analyse_list');
        const labels = checkboxList.getElementsByTagName('label');

        // Remove each label element
        while (labels.length > 0) {
          labels[0].remove();
        }
        const container = document.querySelector('.element-selected-container');
        const elementsSelected = container.querySelectorAll('.element_selected');

        // Remove each element selected
        elementsSelected.forEach(element => {
          element.remove();
        });

        id_brch.value = id;
        fetch(`/patient/get_analyse_branch/${id}/`)  // add the ID parameter to the URL
        .then(response => response.json())
        .then(data => {
          const checkboxList = document.querySelector('.checkbox-type_analyse_list');
          for (let item of data) {
            const newLabel = document.createElement('label');
            const newCheckbox = document.createElement('input');
            newCheckbox.setAttribute('type', 'checkbox');
            newCheckbox.setAttribute('value', item.code_analyse__code);
            newLabel.appendChild(newCheckbox);
            newLabel.appendChild(document.createTextNode(item.code_analyse__nom));
            checkboxList.appendChild(newLabel);
          }const input = document.getElementById('selected_input_analyse');
          const checkboxes2 = document.querySelectorAll('input[type=checkbox]');
          const container = document.querySelector('.element-selected-container');
          
          // Add event listener to each checkbox
          checkboxes2.forEach((checkbox) => {
            checkbox.addEventListener('change', () => {
              if (checkbox.checked) {
                const value = checkbox.value;
                const tag = document.createElement('span');
                tag.classList.add('element_selected');
                const tagValue = document.createElement('span');
                tagValue.classList.add('element_selected_value');
                tagValue.innerText = value;
                const tagClear = document.createElement('span');
                tagClear.classList.add('element_selected_delet_button', 'material-symbols-outlined');
                tagClear.style.fontSize = '18px';
                tagClear.innerText = 'close';
                tagClear.addEventListener('click', () => {
                  container.removeChild(tag);
                  input.value = input.value.split('$').filter(v => v !== value).join('$');
                });
                tag.appendChild(tagValue);
                tag.appendChild(tagClear);
                container.appendChild(tag);
                input.value += `${value}$`;
              } else {
                const tags = container.querySelectorAll('.element_selected');
                tags.forEach((tag) => {
                  if (tag.querySelector('.element_selected_value').innerText === checkbox.value) {
                    container.removeChild(tag);
                    input.value = input.value.split('$').filter(v => v !== checkbox.value).join('$');
                  }
                });
              }
            });
          });
        })
        .catch(error => {
          // handle the error if necessary
        });
        console.log(" form info closed ") ;
        }
      else {
        const alertDiv = document.createElement('div');
        alertDiv.className = 'custom-alert alert-error';
        alertDiv.innerHTML = '<div class="icon__wrapper"><span class="material-symbols-outlined">error</span></div> Please select a date and time by clicking on the time slot.';
        document.body.appendChild(alertDiv);
      
        setTimeout(function() {
          alertDiv.remove();
        }, 3000);
       
      }
      
  
     
    
    };
    
    
    
    function go_to_etape_type_rdv() {  
      $("#etape2").css('transform' ,"scale(0)");
      console.log(" form info closed a ") ;
      $("#etape2").toggleClass('none');
      console.log(" form info closed b ") ;
      $("#type-rdv").css('transform' ,"scale(1)");
      console.log(" form info closed c ") ;
      $("#type-rdv").removeClass('none');
    
      console.log(" form info closedddd ") ;
    };
    function go_to_etape_type_analyse() {  
      
      $("#type-rdv").css('transform' ,"scale(0)");
      console.log(" form info closed c ") ;
      $("#type-rdv").addClass('none');
      console.log(" form info closed b ") ;
  
      $(".type-analyse").css('transform' ,"scale(1)");
      console.log(" ftype-analyse c ") ;
      $(".type-analyse").toggleClass('none');
    
      console.log(" type-analyse ddd ") ;
    };
    function go_to_etape_type_analyse_home() {  
      let rdv_purpose = document.getElementById("rdv_purpose");
      rdv_purpose.value = "blood test";
      $("#etape2").css('transform' ,"scale(0)");
      console.log(" form info closed a ") ;
      $("#etape2").toggleClass('none');
      $("#type-rdv").css('transform' ,"scale(0)");
      console.log(" form info closed c ") ;
      $("#type-rdv").addClass('none');
      console.log(" form info closed b ") ;
  
      $(".type-analyse").css('transform' ,"scale(1)");
      console.log(" ftype-analyse c ") ;
      $(".type-analyse").toggleClass('none');
    
      console.log(" type-analyse ddd ") ;
    };
    function go_to_etape3() {  
  
      $(".type-analyse").css('transform' ,"scale(0)");
      $(".type-analyse").addClass('none');
  
      console.log(" form info closed a ") ;
      $("#type-rdv").css('transform' ,"scale(0)");
      $("#type-rdv").addClass('none');
  
      console.log(" form info closed b ") ;
      $("#etape3").css('transform' ,"scale(1)");
      console.log(" form info closed c ") ;
      $("#etape3").removeClass('none');
    
      console.log(" form info closedddd ") ;
    };
    function go_to_etape4() {  
     
      
      $("#etape4").toggleClass('none');
      
      console.log(" form info closed ") ;
      
      var typeAnalyse = document.getElementById('type_analyse').value;
  // Create the data object to be sent to the server
        var data = {
          analyse: typeAnalyse,
        };
        var ulElement = document.getElementById('conseille_liste');
      fetch('/patient/get_conseille/', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': getCookie('csrftoken') // Include the CSRF token if required by Django
        },
        body: JSON.stringify(data)
      })
      .then(response => {
        // Handle the response from the server
        if (response.ok) {
          // Request successful
          console.log('Data submitted successfully');
          return response.json(); // Parse the response as JSON
        } else {
          // Request failed
          console.error('Failed to submit data');
          throw new Error('Request failed');
        }
      })
      .then(data => {
        // Iterate over the conseilles and create <li> elements
        data.forEach(conseille => {
          var liElement = document.createElement('li');
          liElement.textContent = conseille.conseille;
          ulElement.appendChild(liElement);
        });
      })
      .catch(error => {
        console.error('An error occurred while submitting data:', error);
        // Handle the error if needed
      });

      







    };
    function go_to_etape5() {
      $("#etape3").css('transform', 'scale(0)');
      $("#etape3").addClass('none');
      $("#etape4").css('transform', 'scale(0)');
      $("#etape4").addClass('none');
    
      var rdv_purpose = $("#rdv_purpose").val();
      var appoitment_type = $("#rdv_type").val();
      console.log(appoitment_type)
      if (rdv_purpose === "blood test") {
        $("#etape5").css('transform', 'scale(1)');
        $("#etape5").removeClass('none');
        console.log('Showing etape5 for blood test');




        var typeAnalyse = document.getElementById('type_analyse').value;
        var branch = document.getElementById('id_branch').value;
  // Create the data object to be sent to the server
        var data = {
          analyse: typeAnalyse,
          branch : branch
        };
        
        // Send the data to the server using AJAX
        fetch('/patient/get_prix/', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': getCookie('csrftoken') // Include the CSRF token if required by Django
          },
          body: JSON.stringify(data)
        })
        .then(response => {
          // Handle the response from the server
          if (response.ok) {
            // Request successful
            console.log('Data submitted successfully');
            return response.json(); // Parse the response as JSON
          } else {
            // Request failed
            console.error('Failed to submit data');
            throw new Error('Request failed');
          }
        })
        .then(data => {
          // Process the received data
          console.log(data); // Assuming data is an array of objects
        
          // Iterate over the data and create <p> elements for each item
          data.forEach(item => {
            var pElement = document.createElement('p');
            pElement.textContent = `${item.name} : ${item.price}`;
          
            // Find the parent element to insert the <p> element
            var parentElement = document.getElementById('payment_carte_head_p');
          
            // Append the <p> element to the parent element
            parentElement.appendChild(pElement);
          });
        })
        .catch(error => {
          console.error('An error occurred while submitting data:', error);
          // Handle the error if needed
        });
        
        if (appoitment_type === "at home"){
          var pElement = document.createElement('p');
            pElement.textContent = 'Home tarif (HT): 50.00';
          
            // Find the parent element to insert the <p> element
            var parentElement = document.getElementById('payment_carte_head_p');
          
            // Append the <p> element to the parent element
            parentElement.appendChild(pElement);
        }

      } else if (rdv_purpose === "blood donation") {
        // go_to_etape6();
        const formData = new FormData(document.getElementById('myForm'));

       // Send the data to the server using AJAX
          const xhr = new XMLHttpRequest();
          xhr.open("POST", "/patient/book_appointment/");
          xhr.setRequestHeader('X-CSRFToken', getCookie('csrftoken'));
          xhr.onload = function() {
              if (xhr.status === 200) {
                const response = JSON.parse(xhr.responseText);
                const rdv_id = response.rdv_id;
                
                window.location.href = "/patient/detaille_appointments/" +  rdv_id + "/";
              } else {
                  // Error! Handle the error here.
              }
          };
          xhr.send(formData);
        console.log('Showing etape6 for blood donation');
      } else {
        console.log('Invalid rdv_type value');
      }
    
      console.log('form info closed');
    };
    
    // function go_to_etape6() {  
     
    //   $("#etape5").css('transform' ,"scale(0)");
    //   $("#etape5").addClass('none');
    //   $("#etape6").css('transform' ,"scale(1)");
    //   $("#etape6").removeClass('none');
      
    //   console.log(" form info closed ") ;
    // };
    function   accepte1_term_form() {  
      $("#check_form1").css('transform' ,"scale(1)");
      $("#check_form1").removeClass('none');
      $("#button_form1").addClass('none');
      $("#button_form1").css('transform' ,"scale(0)");
      
    
      $("#button_form2").css('transform' ,"scale(1)");
      $("#button_form2").removeClass('none');
      console.log(" button 2 info open ") ;
    };
    function etape4_closed() {  
      $("#etape4").css('transform', 'scale(0)');
      $("#etape4").toggleClass('none');
      
      console.log("form info closed");
    }
    
    
    function list_type_analyse() {  
      
      $(".btn_filtrage_type_analyse ").css('transform' ,"scale(1)");
      $(".btn_filtrage_type_analyse ").removeClass('none');
    
      console.log(" form info closed ") ;
    };
    function showFilters() {
      var filters = document.getElementById("filters");
      filters.classList.toggle("none");
  }
    function show_list(id) {
      $("#" + id + "-input").click();
    }
    function show_filtrage() {  
       
      if (window.matchMedia('(max-width: 750px)').matches) {
          // Screen width is 750 pixels or less
          $(".criter_list").toggleClass('none');
     } 
    };
  
  
   
    
  
    $(document).ready(function(){
      
     
      $(document).on('click', '#button_form1',  accepte1_term_form );
      
      $(document).on('click', '#button_form2',  etape4_closed);
      
      $(document).on('click', '#delet_form_button_container',  etape4_closed);
      
      
    }); 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  
    
    
    
    
    
    
    
  //   (function() {
   
  
  //     const calendarDaysContainers = document.querySelectorAll('.calendar-days');
  
  //     calendarDaysContainers.forEach(calendarDays => {
  //       const startTimeAttribute = calendarDays.dataset.startTime;
  //       const endTimeAttribute = calendarDays.dataset.endTime;
  //       const afternoonStartTimeAttribute = calendarDays.dataset.afternoonStartTime;
  //       const afternoonEndTimeAttribute = calendarDays.dataset.afternoonEndTime;
      
  //   // Update these lines
  // const morningButton = calendarDays.parentNode.parentNode.querySelector("#Morning");
  // const afternoonButton = calendarDays.parentNode.parentNode.querySelector("#Afternoon");
  
  //       // Move these declarations outside the event listeners
  //       let startTime ,endTime;
      
  //       morningButton.addEventListener("click", function () {
  //         morningButton.classList.add("selected");
  //         morningButton.nextElementSibling.classList.remove("selected");
      
  //         // Update start and end times
  //         const [morningStartHour, morningStartMinute] = startTimeAttribute.split(':').map(Number);
  //         const [morningEndHour, morningEndMinute] = endTimeAttribute.split(':').map(Number);
  //         startTime.setHours(morningStartHour, morningStartMinute, 0, 0);
  //         endTime.setHours(morningEndHour, morningEndMinute, 0, 0);
      
  //         updateCalendarDays(currentDay, calendarDays);
  //       });
      
  //       afternoonButton.addEventListener("click", function () {
  //         afternoonButton.classList.add("selected");
  //         afternoonButton.previousElementSibling.classList.remove("selected");
      
  //         // Update start and end times
  //         const [afternoonStartHour, afternoonStartMinute] = afternoonStartTimeAttribute.split(':').map(Number);
  //         const [afternoonEndHour, afternoonEndMinute] = afternoonEndTimeAttribute.split(':').map(Number);
  //         startTime.setHours(afternoonStartHour, afternoonStartMinute, 0, 0);
  //         endTime.setHours(afternoonEndHour, afternoonEndMinute, 0, 0);
      
  //         updateCalendarDays(currentDay, calendarDays);
  //       });
      
  
  
      
  //     const leftArrow = calendarDays.parentElement.querySelector('.arrow-left');
  //     const rightArrow = calendarDays.parentElement.querySelector('.arrow-right');
  //     const daysToShow = 4;
  //     let currentDay = 0;
  //   const chosenSlots = document.querySelectorAll('.calendre_availabile_day_slot');
    
  //   // Function to generate calendar days HTML
  //   const generateDaysHTML = (currentDay) => {
  //     let html = '';
  //     for (let i = currentDay; i <= currentDay + daysToShow; i++) {
  //       // Generate date object for each day
  //       const date = new Date();
  //       date.setDate(date.getDate() + i);
    
  //       // Generate HTML for each slot
  //       let slotHtml = '';
    
  //       if (document.getElementById('Morning').classList.contains('selected')) {
  //         const [startHour, startMinute] = startTimeAttribute.split(':').map(Number);
  //         const [endHour, endMinute] = endTimeAttribute.split(':').map(Number);
  //         startTime = new Date(date);
  //         startTime.setHours(startHour, startMinute, 0, 0);
  //         endTime = new Date(date);
  //         endTime.setHours(endHour, endMinute, 0, 0);
  //       }
  //       else if (document.getElementById('Afternoon').classList.contains('selected')) {
  //   const [startHour, startMinute] = afternoonStartTimeAttribute.split(':').map(Number);
  //   const [endHour, endMinute] = afternoonEndTimeAttribute.split(':').map(Number);
  //   startTime = new Date(date);
  //   startTime.setHours(startHour, startMinute, 0, 0);
  //   endTime = new Date(date);
  //   endTime.setHours(endHour, endMinute, 0, 0);
  // }
  
  //       let count = 0;
  //       let hiddenSlotHtml = '';
  //       while (startTime <= endTime) {
  //         if (count < 3) {
  //           slotHtml += `<div class="calendre_availabile_day_slot" data-date="${date.toISOString()}">${startTime.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}</div>`;
  //         } else {
  //           hiddenSlotHtml += `<div class="calendre_availabile_day_slot hidden" data-date="${date.toISOString()}">${startTime.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}</div>`;
  //         }
  //         startTime.setTime(startTime.getTime() + 30 * 60000); // 10 minutes
  //         count++;
  //       }
    
  //       // Generate HTML for each day
  //       html += `
  //       <div class="calendre_availabile_day">
  //         <div class="calendre_availabile_day_title">
  //           <div class="calendre_availabile_day_name">${date.toLocaleString('default', { weekday: 'long' })}</div>
  //           <div class="calendre_availabile_day_date">${date.toLocaleString('default', { month: 'short', day: 'numeric' })}</div>
  //         </div>
  //         <div class="calendre_availabile_day_slots">
  //           ${slotHtml}
  //           ${hiddenSlotHtml}
  //           ${count > 5 ? `<div class="show-more-btn">More <span class="material-symbols-outlined ">expand_more</span></div>` : ''}
  //           ${hiddenSlotHtml && hiddenSlotHtml !== '' ? `<div class="show-less-btn hidden">Less <span class="material-symbols-outlined ">expand_less</span></div>` : ''}
  //         </div>
  //       </div>
  //   `;
  //       if (hiddenSlotHtml === '') {
  //         html = html.replace('More', '');
  //       }
  //     }
  
  //     return html;
  //   };
    
   
        
        
        
        
  
  //   // Add event listener to Show More button
  //   calendarDays.addEventListener('click', (event) => {
  //     if (event.target.classList.contains('show-more-btn')) {
  //       const slotsContainer = event.target.parentNode;
  //       const hiddenSlots = slotsContainer.querySelectorAll('.hidden');
  //       hiddenSlots.forEach((slot) => {
  //         slot.classList.remove('hidden');
  //       });
  //       event.target.classList.add('hidden');
  //       const showLessBtn = slotsContainer.querySelector('.show-less-btn');
  //       showLessBtn.classList.remove('hidden');
     
  //     } else if (event.target.classList.contains('show-less-btn')) {
  //       const slotsContainer = event.target.parentNode;
  //       const allSlots = slotsContainer.querySelectorAll('.calendre_availabile_day_slot');
  //       const hiddenSlots = slotsContainer.querySelectorAll('.hidden');
  //       hiddenSlots.forEach((slot) => {
  //         slot.classList.remove('hidden');
  //       });
  //       allSlots.forEach((slot, index) => {
  //         if (index >= 3) {
  //           slot.classList.add('hidden');
  //         }
  //       });
  //       event.target.classList.add('hidden');
  //       const showMoreBtn = slotsContainer.querySelector('.show-more-btn');
  //       showMoreBtn.classList.remove('hidden');
  //     }
  //   });
  
    
    
    
  //    // Function to update calendar days HTML
  //    const updateCalendarDays = (currentDay, calendarDays) => {
  //     calendarDays.innerHTML = generateDaysHTML(currentDay);
  //     const newChosenSlots = document.querySelectorAll('.calendre_availabile_day_slot');
  //     newChosenSlots.forEach(slot => {
  //       slot.addEventListener('click', () => {
  //         newChosenSlots.forEach(slot => {
  //           slot.style.backgroundColor = '#E61F57';
  //           slot.style.color = 'white';
  //         });
  //         slot.style.backgroundColor = '#46807F';
  //         slot.style.color = 'white';
  //         const time = slot.textContent.trim();
  //         const rdvTime = document.getElementById('rdv_time');
  //         rdvTime.value = time;
  //         const id_brch = document.getElementById('rdv_time');
  //         const slotDate = new Date(slot.getAttribute('data-date'));
  //         const currentYear = new Date().getFullYear();
  //         slotDate.setFullYear(currentYear);
  //         const rdvDate = document.getElementById('rdv_date');
  //         rdvDate.value = slotDate.toISOString().slice(0,10);
  
  
  // // Format the date as "Thursday, March 2, 2023"
  // const formattedDate = slotDate.toLocaleString('en-US', {
  //   weekday: 'long',
  //   day: 'numeric',
  //   month: 'long',
  //   year: 'numeric'
  // });
  // // Combine the date and time in the desired format
  // const combinedDateTime = `${formattedDate} on ${time}`;
  
  // // Update the rdvTime and rdvDate values for each date_and_time element
  // const progressionTimes = document.querySelectorAll('.date_and_time');
  // const selectedTimes = document.querySelectorAll('.type_rendez-vous_type_containe_confirmation_p');
  
  // selectedTimes.forEach(selectedTime => {
  //   selectedTime.textContent = "you selected the " + combinedDateTime;
  // });
  
  // progressionTimes.forEach(progressionTime => {
  //   progressionTime.parentElement.parentElement.classList.remove('none');
  //   progressionTime.textContent = combinedDateTime;
  // });
  
  //       });
  //     });
      
  //   };
    
    
  //   // Click event listener for left arrow
  //   leftArrow.addEventListener('click', () => {
  //     if (currentDay > 0) {
  //       currentDay -= daysToShow;
  //       updateCalendarDays(currentDay, calendarDays);
  //     }
  //   });
    
  //   // Click event listener for right arrow
  //   rightArrow.addEventListener('click', () => {
  //     currentDay += daysToShow;
  //     updateCalendarDays(currentDay, calendarDays);
  //   });
    
   
    
  
  
  
  
  
  
  //   function checkMediaQuery() {
  //     if (window.matchMedia('(max-width: 750px)').matches) {
  //       // Screen width is 750 pixels or less
  //       $(".criter_list").add('none');
  //     } else {
  //       // Screen width is greater than 750 pixels
  //       $(".criter_list").remove('none');
  //     }
  //   }
  
  
  //    // Initial call to update calendar days HTML
  //    updateCalendarDays(currentDay, calendarDays);
  
  //     // Call the function on page load and whenever the window is resized
  //     checkMediaQuery();
  //     window.addEventListener('resize', checkMediaQuery);
  //     // Initial call to update calendar days HTML
  //   morningButton.click(); // Add this line to trigger the click event on the morning button
  //   });
  // })();
  





//   (function () {
  
//     let currentDay = 0; // Add this line
// const parseAppointments = (data) => {
//   if (!data) {
//     return [];
//   }

//   const appointmentsList = data.split('$');
//   return appointmentsList.map(app => {
//     const [dateString, time] = app.split('>');
//     const date = new Date(dateString);
//     return { date, time };
//   });
// };

    
// const parseWorkDayTimes = (data) => {
//   if (!data) {
//     return [];
//   }

//   // Replace French day names with English day names
//   data = data.replace(/lundi/g, 'Monday')
//              .replace(/mardi/g, 'Tuesday')
//              .replace(/mercredi/g, 'Wednesday')
//              .replace(/jeudi/g, 'Thursday')
//              .replace(/vendredi/g, 'Friday')
//              .replace(/samedi/g, 'Saturday')
//              .replace(/dimanche/g, 'Sunday');

//   const workDayTimesList = data.split('$');
//   return workDayTimesList.map(dayTime => {
//     const [dayName, morningStartTime, afternoonEndTime] = dayTime.split('>');
//     return { dayName, morningStartTime, afternoonEndTime };
//   });
// };

    
// // ... rest of your JavaScript code ...



//     const calendarDaysContainers = document.querySelectorAll('.calendar-days');

//   calendarDaysContainers.forEach(calendarDays => {
      



//               const hour_apointment = calendarDays.dataset.appointmenthour;







//     const morningButton = calendarDays.parentNode.parentNode.querySelector("#Morning");
// const afternoonButton = calendarDays.parentNode.parentNode.querySelector("#Afternoon");


    





 


//       morningButton.addEventListener("click", function () {
//         morningButton.classList.add("selected");
//         morningButton.nextElementSibling.classList.remove("selected");
    

    
//        updateCalendarDays(currentDay, calendarDays);

//       });

//       afternoonButton.addEventListener("click", function () {
//         afternoonButton.classList.add("selected");
//         afternoonButton.previousElementSibling.classList.remove("selected");
    
//        updateCalendarDays(currentDay, calendarDays);

//       });

    


// const workdaysData = calendarDays.dataset.workdays;

//       const workdays = parseWorkDayTimes(workdaysData); 
//       console.log(workdays)

//               const appointmentsData = calendarDays.dataset.appointment;
//         const appointments = parseAppointments(appointmentsData);
    
//   // Update these lines

//       // Move these declarations outside the event listeners

   




    
//     const leftArrow = calendarDays.parentElement.querySelector('.arrow-left');
//     const rightArrow = calendarDays.parentElement.querySelector('.arrow-right');
//     const daysToShow = 5;
    
//   const chosenSlots = document.querySelectorAll('.calendre_availabile_day_slot');
  
//   // Function to generate calendar days HTML
//       const generateDaysHTML = (currentDay) => {
//   let html = '';
//   let daysAdded = 0;
//         let dayIndex = currentDay;
//         while (daysAdded < daysToShow) {
//           // Generate date object for each day
//           const date = new Date();
//           date.setDate(date.getDate() + dayIndex);
          
 
//           // Get dayName of the current date
//           const currentDayName = date.toLocaleString('en-US', { weekday: 'long' });

//           console.log('currentDayName:', currentDayName);
//           // Skip Friday
// if (currentDayName !== 'Friday') {
//           const workDay = workdays.find(workDay => workDay.dayName === currentDayName);
//           console.log('workDay:', workDay);

           
      
      
           
//           let morningStartTime, afternoonEndTime;
//           if (workDay) {
//             morningStartTime = workDay.morningStartTime;
//             afternoonEndTime = workDay.afternoonEndTime;
//           } else {
//             // If no matching workday is found, set default values (or skip the day)
//             morningStartTime = '07:00';
//             afternoonEndTime = '15:30';
//           }







          
//           // Convert the start and end times to Date objects
//           const startTime = new Date(date);
        
//           const endTime = new Date(date);
         
//           // Set fixed morning end time and afternoon start time
//           const morningEndTime = '12:00';
//           const afternoonStartTime = '13:00';
//           // Generate HTML for each slot
//           let slotHtml = '';
  
//           if (document.getElementById('Morning').classList.contains('selected')) {
//             startTime.setHours(morningStartTime.split(':')[0], morningStartTime.split(':')[1]);
//             console.log(startTime)
//             endTime.setHours(morningEndTime.split(':')[0], morningEndTime.split(':')[1]);
//             console.log(endTime)
//           }
//           else if (document.getElementById('Afternoon').classList.contains('selected')) {
//             startTime.setHours(afternoonStartTime.split(':')[0], afternoonStartTime.split(':')[1]);
//             console.log(startTime)
//             endTime.setHours(afternoonEndTime.split(':')[0], afternoonEndTime.split(':')[1]);
//             console.log(endTime)
//           }

//           let count = 0;
//           let hiddenSlotHtml = '';
//           if (morningStartTime !== '' && afternoonEndTime !== '') {

//             while (startTime <= endTime) {
//               const slotDate = new Date(startTime);
//               const isOccupied = appointments.some(app => app.date.toISOString().slice(0, 10) === slotDate.toISOString().slice(0, 10) && app.time === startTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }));

  
//               if (count < 3) {
//                 if (!isOccupied) {
//                   slotHtml += `<div class="calendre_availabile_day_slot slot" data-date="${date.toISOString()}">${startTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</div>`;
//                 } else {
//                   slotHtml += `<div class="calendre_empty_slot slot"><div class="calendre_empty_slot_lign"></div></div>`;
      
//                 }
//               } else {
//                 if (!isOccupied) {
//                   hiddenSlotHtml += `<div class="calendre_availabile_day_slot  slot hidden" data-date="${date.toISOString()}">${startTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</div>`;
//                 } else {
//                   hiddenSlotHtml += `<div class="calendre_empty_slot  slot hidden"><div class="calendre_empty_slot_lign"></div></div>`;
//                 }
          
//               }


//               startTime.setTime(startTime.getTime() +(60/hour_apointment)  * 60000); // 10 minutes
//               count++;
//             }
//           }
//           else {
//             while (count < 3) {
//               slotHtml += `<div class="calendre_empty_slot slot"><div class="calendre_empty_slot_lign"></div></div>`;
//               count++;
//             }
//           }

//           // Generate HTML for each day
//           html += `
//       <div class="calendre_availabile_day">
//         <div class="calendre_availabile_day_title">
//           <div class="calendre_availabile_day_name">${date.toLocaleString('en-US', { weekday: 'short' })}</div>
//           <div class="calendre_availabile_day_date">${date.toLocaleString('en-US', { month: 'short', day: 'numeric' })}</div>
//         </div>
//         <div class="calendre_availabile_day_slots">
//           ${slotHtml}
//           ${hiddenSlotHtml}
//           ${count > 5 ? `<div class="show-more-btn">More <span class="material-symbols-outlined ">expand_more</span></div>` : '<div class="show-more-btn" style="visibility: hidden;">More <span class="material-symbols-outlined ">expand_more</span></div>'}

//           ${hiddenSlotHtml && hiddenSlotHtml !== '' ? `<div class="show-less-btn hidden">Less <span class="material-symbols-outlined ">expand_less</span></div>` : ''}
//         </div>
//       </div>
//   `;
//           if (hiddenSlotHtml === '') {
//             html = html.replace('More', '');
//           }
//    daysAdded++;
//           }
//               // Increment the dayIndex for the next iteration
//     dayIndex++;
//     }

//     return html;
//   };
  

      
      
      
      

//   // Add event listener to Show More button
//   calendarDays.addEventListener('click', (event) => {
//     console.log("hhhhhhhhhhhhhhhh")
//     if (event.target.classList.contains('show-more-btn')) {
//       const slotsContainer = event.target.parentNode;
//       const hiddenSlots = slotsContainer.querySelectorAll('.hidden');
//       hiddenSlots.forEach((slot) => {
//         slot.classList.remove('hidden');
//       });
//       event.target.classList.add('hidden');
//       const showLessBtn = slotsContainer.querySelector('.show-less-btn');
//       showLessBtn.classList.remove('hidden');
   
//     } else if (event.target.classList.contains('show-less-btn')) {
//       const slotsContainer = event.target.parentNode;
//       const allSlots = slotsContainer.querySelectorAll('.slot');
      
//       const hiddenSlots = slotsContainer.querySelectorAll('.hidden');
//       hiddenSlots.forEach((slot) => {
//         slot.classList.remove('hidden');
//       });
//       allSlots.forEach((slot, index) => {
//         if (index >= 3) {
//           slot.classList.add('hidden');
//         }
//       });
//       event.target.classList.add('hidden');
//       const showMoreBtn = slotsContainer.querySelector('.show-more-btn');
//       showMoreBtn.classList.remove('hidden');
//     }
//   });

  
  
  
//    // Function to update calendar days HTML
// const updateCalendarDays = (currentDay, calendarDays) => {
//     calendarDays.innerHTML = generateDaysHTML(currentDay);
//     const newChosenSlots = document.querySelectorAll('.calendre_availabile_day_slot');
//     newChosenSlots.forEach(slot => {
//       slot.addEventListener('click', () => {
//         newChosenSlots.forEach(slot => {
//           slot.style.backgroundColor = '#E61F57';
//           slot.style.color = 'white';
//         });
//         slot.style.backgroundColor = '#46807F';
//         slot.style.color = 'white';
//         const time = slot.textContent.trim();
//         const rdvTime = document.getElementById('rdv_time');
//         rdvTime.value = time;
        
//         const slotDate = new Date(slot.getAttribute('data-date'));
//         const currentYear = new Date().getFullYear();
//         slotDate.setFullYear(currentYear);
//         const rdvDate = document.getElementById('rdv_date');
//         rdvDate.value = slotDate.toISOString().slice(0,10);


// // Format the date as "Thursday, March 2, 2023"
// const formattedDate = slotDate.toLocaleString('en-US', {
//   weekday: 'long',
//   day: 'numeric',
//   month: 'long',
//   year: 'numeric'
// });
// // Combine the date and time in the desired format
// const combinedDateTime = `${formattedDate} on ${time}`;

// // Update the rdvTime and rdvDate values for each date_and_time element
// const progressionTimes = document.querySelectorAll('.date_and_time');
// const selectedTimes = document.querySelectorAll('.type_rendez-vous_type_containe_confirmation_p');

// selectedTimes.forEach(selectedTime => {
//   selectedTime.textContent = "you selected the " + combinedDateTime;
// });

// progressionTimes.forEach(progressionTime => {
//   progressionTime.parentElement.parentElement.classList.remove('none');
//   progressionTime.textContent = combinedDateTime;
// });

//       });
//     });
    
//   };
  
  
//   // Click event listener for left arrow
//   leftArrow.addEventListener('click', () => {
//     if (currentDay > 0) {
//       currentDay -= daysToShow;
//      updateCalendarDays(currentDay, calendarDays);

//     }
//   });
  
//   // Click event listener for right arrow
//   rightArrow.addEventListener('click', () => {
//     currentDay += daysToShow;
//    updateCalendarDays(currentDay, calendarDays);

//   });
  
 
  






//   function checkMediaQuery() {
//     if (window.matchMedia('(max-width: 750px)').matches) {
//       // Screen width is 750 pixels or less
//       $(".criter_list").add('none');
//     } else {
//       // Screen width is greater than 750 pixels
//       $(".criter_list").remove('none');
//     }
//   }


//    // Initial call to update calendar days HTML
//   updateCalendarDays(currentDay, calendarDays);


//     // Call the function on page load and whenever the window is resized
//     checkMediaQuery();
//     window.addEventListener('resize', checkMediaQuery);
//     // Initial call to update calendar days HTML
//      // Add this line to trigger the click event on the morning button
//   });
// })();
  
  
// function appointment_time_slot() {
  
//   let currentDay = 0; // Add this line
// const parseAppointments = (data) => {
// if (!data) {
//   return [];
// }

// const appointmentsList = data.split('$');
// return appointmentsList.map(app => {
//   const [dateString, time] = app.split('>');
//   const date = new Date(dateString);
//   return { date, time };
// });
// };

  
// const parseWorkDayTimes = (data) => {
// if (!data) {
//   return [];
// }

// // Replace French day names with English day names
// data = data.replace(/lundi/g, 'Monday')
//            .replace(/mardi/g, 'Tuesday')
//            .replace(/mercredi/g, 'Wednesday')
//            .replace(/jeudi/g, 'Thursday')
//            .replace(/vendredi/g, 'Friday')
//            .replace(/samedi/g, 'Saturday')
//            .replace(/dimanche/g, 'Sunday');

// const workDayTimesList = data.split('$');
// return workDayTimesList.map(dayTime => {
//   const [dayName, morningStartTime, afternoonEndTime] = dayTime.split('>');
//   return { dayName, morningStartTime, afternoonEndTime };
// });
// };

  
// // ... rest of your JavaScript code ...



//   const calendarDaysContainers = document.querySelectorAll('.calendar-days');

// calendarDaysContainers.forEach(calendarDays => {
    



//             const hour_apointment = calendarDays.dataset.appointmenthour;







//   const morningButton = calendarDays.parentNode.parentNode.querySelector("#Morning");
// const afternoonButton = calendarDays.parentNode.parentNode.querySelector("#Afternoon");


  








//     morningButton.addEventListener("click", function () {
//       morningButton.classList.add("selected");
//       morningButton.nextElementSibling.classList.remove("selected");
  

  
//      updateCalendarDays(currentDay, calendarDays);

//     });

//     afternoonButton.addEventListener("click", function () {
//       afternoonButton.classList.add("selected");
//       afternoonButton.previousElementSibling.classList.remove("selected");
  
//      updateCalendarDays(currentDay, calendarDays);

//     });

  


// const workdaysData = calendarDays.dataset.workdays;

//     const workdays = parseWorkDayTimes(workdaysData); 
//     console.log(workdays)

//             const appointmentsData = calendarDays.dataset.appointment;
//       const appointments = parseAppointments(appointmentsData);
  
// // Update these lines

//     // Move these declarations outside the event listeners

 




  
//   const leftArrow = calendarDays.parentElement.querySelector('.arrow-left');
//   const rightArrow = calendarDays.parentElement.querySelector('.arrow-right');
//   const daysToShow = 5;
  
// const chosenSlots = document.querySelectorAll('.calendre_availabile_day_slot');

// // Function to generate calendar days HTML
//     const generateDaysHTML = (currentDay) => {
// let html = '';
// let daysAdded = 0;
//       let dayIndex = currentDay;
//       while (daysAdded < daysToShow) {
//         // Generate date object for each day
//         const date = new Date();
//         date.setDate(date.getDate() + dayIndex);
        

//         // Get dayName of the current date
//         const currentDayName = date.toLocaleString('en-US', { weekday: 'long' });

//         console.log('currentDayName:', currentDayName);
//         // Skip Friday
// if (currentDayName !== 'Friday') {
//         const workDay = workdays.find(workDay => workDay.dayName === currentDayName);
//         console.log('workDay:', workDay);

         
    
    
         
//         let morningStartTime, afternoonEndTime;
//         if (workDay) {
//           morningStartTime = workDay.morningStartTime;
//           afternoonEndTime = workDay.afternoonEndTime;
//         } else {
//           // If no matching workday is found, set default values (or skip the day)
//           morningStartTime = '07:00';
//           afternoonEndTime = '15:30';
//         }







        
//         // Convert the start and end times to Date objects
//         const startTime = new Date(date);
      
//         const endTime = new Date(date);
       
//         // Set fixed morning end time and afternoon start time
//         const morningEndTime = '12:00';
//         const afternoonStartTime = '13:00';
//         // Generate HTML for each slot
//         let slotHtml = '';

//         if (document.getElementById('Morning').classList.contains('selected')) {
//           startTime.setHours(morningStartTime.split(':')[0], morningStartTime.split(':')[1]);
//           console.log(startTime)
//           endTime.setHours(morningEndTime.split(':')[0], morningEndTime.split(':')[1]);
//           console.log(endTime)
//         }
//         else if (document.getElementById('Afternoon').classList.contains('selected')) {
//           startTime.setHours(afternoonStartTime.split(':')[0], afternoonStartTime.split(':')[1]);
//           console.log(startTime)
//           endTime.setHours(afternoonEndTime.split(':')[0], afternoonEndTime.split(':')[1]);
//           console.log(endTime)
//         }

//         let count = 0;
//         let hiddenSlotHtml = '';
//         if (morningStartTime !== '' && afternoonEndTime !== '') {

//           while (startTime <= endTime) {
//             const slotDate = new Date(startTime);
//             const isOccupied = appointments.some(app => app.date.toISOString().slice(0, 10) === slotDate.toISOString().slice(0, 10) && app.time === startTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }));


//             if (count < 3) {
//               if (!isOccupied) {
//                 slotHtml += `<div class="calendre_availabile_day_slot slot" data-date="${date.toISOString()}">${startTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</div>`;
//               } else {
//                 slotHtml += `<div class="calendre_empty_slot slot"><div class="calendre_empty_slot_lign"></div></div>`;
    
//               }
//             } else {
//               if (!isOccupied) {
//                 hiddenSlotHtml += `<div class="calendre_availabile_day_slot  slot hidden" data-date="${date.toISOString()}">${startTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</div>`;
//               } else {
//                 hiddenSlotHtml += `<div class="calendre_empty_slot  slot hidden"><div class="calendre_empty_slot_lign"></div></div>`;
//               }
        
//             }


//             startTime.setTime(startTime.getTime() +(60/hour_apointment)  * 60000); // 10 minutes
//             count++;
//           }
//         }
//         else {
//           while (count < 3) {
//             slotHtml += `<div class="calendre_empty_slot slot"><div class="calendre_empty_slot_lign"></div></div>`;
//             count++;
//           }
//         }

//         // Generate HTML for each day
//         html += `
//     <div class="calendre_availabile_day">
//       <div class="calendre_availabile_day_title">
//         <div class="calendre_availabile_day_name">${date.toLocaleString('en-US', { weekday: 'short' })}</div>
//         <div class="calendre_availabile_day_date">${date.toLocaleString('en-US', { month: 'short', day: 'numeric' })}</div>
//       </div>
//       <div class="calendre_availabile_day_slots">
//         ${slotHtml}
//         ${hiddenSlotHtml}
//         ${count > 5 ? `<div class="show-more-btn">More <span class="material-symbols-outlined ">expand_more</span></div>` : '<div class="show-more-btn" style="visibility: hidden;">More <span class="material-symbols-outlined ">expand_more</span></div>'}

//         ${hiddenSlotHtml && hiddenSlotHtml !== '' ? `<div class="show-less-btn hidden">Less <span class="material-symbols-outlined ">expand_less</span></div>` : ''}
//       </div>
//     </div>
// `;
//         if (hiddenSlotHtml === '') {
//           html = html.replace('More', '');
//         }
//  daysAdded++;
//         }
//             // Increment the dayIndex for the next iteration
//   dayIndex++;
//   }

//   return html;
// };


    
    
    
    

// // Add event listener to Show More button
// calendarDays.addEventListener('click', (event) => {
//   console.log("hhhhhhhhhhhhhhhh")
//   if (event.target.classList.contains('show-more-btn')) {
//     const slotsContainer = event.target.parentNode;
//     const hiddenSlots = slotsContainer.querySelectorAll('.hidden');
//     hiddenSlots.forEach((slot) => {
//       slot.classList.remove('hidden');
//     });
//     event.target.classList.add('hidden');
//     const showLessBtn = slotsContainer.querySelector('.show-less-btn');
//     showLessBtn.classList.remove('hidden');
 
//   } else if (event.target.classList.contains('show-less-btn')) {
//     const slotsContainer = event.target.parentNode;
//     const allSlots = slotsContainer.querySelectorAll('.slot');
    
//     const hiddenSlots = slotsContainer.querySelectorAll('.hidden');
//     hiddenSlots.forEach((slot) => {
//       slot.classList.remove('hidden');
//     });
//     allSlots.forEach((slot, index) => {
//       if (index >= 3) {
//         slot.classList.add('hidden');
//       }
//     });
//     event.target.classList.add('hidden');
//     const showMoreBtn = slotsContainer.querySelector('.show-more-btn');
//     showMoreBtn.classList.remove('hidden');
//   }
// });




//  // Function to update calendar days HTML
// const updateCalendarDays = (currentDay, calendarDays) => {
//   calendarDays.innerHTML = generateDaysHTML(currentDay);
//   const newChosenSlots = document.querySelectorAll('.calendre_availabile_day_slot');
//   newChosenSlots.forEach(slot => {
//     slot.addEventListener('click', () => {
//       newChosenSlots.forEach(slot => {
//         slot.style.backgroundColor = '#E61F57';
//         slot.style.color = 'white';
//       });
//       slot.style.backgroundColor = '#46807F';
//       slot.style.color = 'white';
//       const time = slot.textContent.trim();
//       const rdvTime = document.getElementById('rdv_time');
//       rdvTime.value = time;
      
//       const slotDate = new Date(slot.getAttribute('data-date'));
//       const currentYear = new Date().getFullYear();
//       slotDate.setFullYear(currentYear);
//       const rdvDate = document.getElementById('rdv_date');
//       rdvDate.value = slotDate.toISOString().slice(0,10);


// // Format the date as "Thursday, March 2, 2023"
// const formattedDate = slotDate.toLocaleString('en-US', {
// weekday: 'long',
// day: 'numeric',
// month: 'long',
// year: 'numeric'
// });
// // Combine the date and time in the desired format
// const combinedDateTime = `${formattedDate} on ${time}`;

// // Update the rdvTime and rdvDate values for each date_and_time element
// const progressionTimes = document.querySelectorAll('.date_and_time');
// const selectedTimes = document.querySelectorAll('.type_rendez-vous_type_containe_confirmation_p');

// selectedTimes.forEach(selectedTime => {
// selectedTime.textContent = "you selected the " + combinedDateTime;
// });

// progressionTimes.forEach(progressionTime => {
// progressionTime.parentElement.parentElement.classList.remove('none');
// progressionTime.textContent = combinedDateTime;
// });

//     });
//   });
  
// };


// // Click event listener for left arrow
// leftArrow.addEventListener('click', () => {
//   if (currentDay > 0) {
//     currentDay -= daysToShow;
//    updateCalendarDays(currentDay, calendarDays);

//   }
// });

// // Click event listener for right arrow
// rightArrow.addEventListener('click', () => {
//   currentDay += daysToShow;
//  updateCalendarDays(currentDay, calendarDays);

// });









// function checkMediaQuery() {
//   if (window.matchMedia('(max-width: 750px)').matches) {
//     // Screen width is 750 pixels or less
//     $(".criter_list").add('none');
//   } else {
//     // Screen width is greater than 750 pixels
//     $(".criter_list").remove('none');
//   }
// }


//  // Initial call to update calendar days HTML
// updateCalendarDays(currentDay, calendarDays);


//   // Call the function on page load and whenever the window is resized
//   checkMediaQuery();
//   window.addEventListener('resize', checkMediaQuery);
//   // Initial call to update calendar days HTML
//    // Add this line to trigger the click event on the morning button
// });
// };



function appointment_time_slot() {
  let currentDay = 0;

  const parseAppointments = (data) => {
    if (!data) {
      return [];
    }

    const appointmentsList = data.split('$');
    return appointmentsList.map(app => {
      const [dateString, time] = app.split('>');
      const date = new Date(dateString);
      return { date, time };
    });
  };

  const parseWorkDayTimes = (data) => {
    if (!data) {
      return [];
    }

    data = data.replace(/lundi/g, 'Monday')
               .replace(/mardi/g, 'Tuesday')
               .replace(/mercredi/g, 'Wednesday')
               .replace(/jeudi/g, 'Thursday')
               .replace(/vendredi/g, 'Friday')
               .replace(/samedi/g, 'Saturday')
               .replace(/dimanche/g, 'Sunday');

    const workDayTimesList = data.split('$');
    return workDayTimesList.map(dayTime => {
      const [dayName, morningStartTime, afternoonEndTime] = dayTime.split('>');
      return { dayName, morningStartTime, afternoonEndTime };
    });
  };

  const calendarDaysContainers = document.querySelectorAll('.calendar-days');

  calendarDaysContainers.forEach(calendarDays => {
    const hour_appointment = calendarDays.dataset.appointmenthour;

    const morningButton = calendarDays.parentNode.parentNode.querySelector("#Morning");
    const afternoonButton = calendarDays.parentNode.parentNode.querySelector("#Afternoon");

    morningButton.addEventListener("click", function () {
      morningButton.classList.add("selected");
      morningButton.nextElementSibling.classList.remove("selected");
      updateCalendarDays(currentDay, calendarDays);
    });

    afternoonButton.addEventListener("click", function () {
      afternoonButton.classList.add("selected");
      afternoonButton.previousElementSibling.classList.remove("selected");
      updateCalendarDays(currentDay, calendarDays);
    });

    const workdaysData = calendarDays.dataset.workdays;
    const workdays = parseWorkDayTimes(workdaysData);
    const appointmentsData = calendarDays.dataset.appointment;
    const appointments = parseAppointments(appointmentsData);

    const generateDaysHTML = (currentDay) => {
      let html = '';
      let daysAdded = 0;
      let dayIndex = currentDay;
    
      const currentDate = new Date();
      const startDate = new Date();
      startDate.setDate(currentDate.getDate() + 2); // Start from two days after today
    
      const daysToShow = 4; // Number of days to display
    
      while (daysAdded < daysToShow) {
        const date = new Date(startDate);
        date.setDate(startDate.getDate() + dayIndex);
    
        const currentDayName = date.toLocaleString('en-US', { weekday: 'long' });
    
        const workDay = workdays.find(workDay => workDay.dayName === currentDayName);
    
        if (workDay && workDay.morningStartTime !== '' && workDay.afternoonEndTime !== '') {
          const morningStartTime = workDay.morningStartTime;
          const afternoonEndTime = workDay.afternoonEndTime;
    
          const startTime = new Date(date);
          const endTime = new Date(date);
    
          const morningEndTime = '12:00';
          const afternoonStartTime = '13:00';
    
          let slotHtml = '';
    
          if (document.getElementById('Morning').classList.contains('selected')) {
            startTime.setHours(morningStartTime.split(':')[0], morningStartTime.split(':')[1]);
            endTime.setHours(morningEndTime.split(':')[0], morningEndTime.split(':')[1]);
          } else if (document.getElementById('Afternoon').classList.contains('selected')) {
            startTime.setHours(afternoonStartTime.split(':')[0], afternoonStartTime.split(':')[1]);
            endTime.setHours(afternoonEndTime.split(':')[0], afternoonEndTime.split(':')[1]);
          }
    
          let count = 0;
          let hiddenSlotHtml = '';
    
          while (startTime <= endTime) {
            const slotDate = new Date(startTime);
            const isOccupied = appointments.some(app => app.date.toISOString().slice(0, 10) === slotDate.toISOString().slice(0, 10) && app.time === startTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }));
    
            if (count < 3) {
              if (!isOccupied) {
                slotHtml += `<div class="calendre_availabile_day_slot slot" data-date="${date.toISOString()}">${startTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</div>`;
              } else {
                slotHtml += `<div class="calendre_empty_slot slot"><div class="calendre_empty_slot_lign"></div></div>`;
              }
            } else {
              if (!isOccupied) {
                hiddenSlotHtml += `<div class="calendre_availabile_day_slot slot hidden" data-date="${date.toISOString()}">${startTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</div>`;
              } else {
                hiddenSlotHtml += `<div class="calendre_empty_slot slot hidden"><div class="calendre_empty_slot_lign"></div></div>`;
              }
            }
    
            startTime.setTime(startTime.getTime() + (60 / hour_appointment) * 60000); // 10 minutes
            count++;
          }
    
          html += `
            <div class="calendre_availabile_day">
              <div class="calendre_availabile_day_title">
                <div class="calendre_availabile_day_name">${date.toLocaleString('en-US', { weekday: 'short' })}</div>
                <div class="calendre_availabile_day_date">${date.toLocaleString('en-US', { month: 'short', day: 'numeric' })}</div>
              </div>
              <div class="calendre_availabile_day_slots">
                ${slotHtml}
                ${hiddenSlotHtml}
                ${count > 5 ? `<div class="show-more-btn">More <span class="material-symbols-outlined ">expand_more</span></div>` : '<div class="show-more-btn" style="visibility: hidden;">More <span class="material-symbols-outlined ">expand_more</span></div>'}
                ${hiddenSlotHtml && hiddenSlotHtml !== '' ? `<div class="show-less-btn hidden">Less <span class="material-symbols-outlined ">expand_less</span></div>` : ''}
              </div>
            </div>
          `;
    
          if (hiddenSlotHtml === '') {
            html = html.replace('More', '');
          }
    
          daysAdded++;
        }
    
        dayIndex++;
      }
    
      return html;
    };
    
    
    

    calendarDays.addEventListener('click', (event) => {
      if (event.target.classList.contains('show-more-btn')) {
        const slotsContainer = event.target.parentNode;
        const hiddenSlots = slotsContainer.querySelectorAll('.hidden');
        hiddenSlots.forEach((slot) => {
          slot.classList.remove('hidden');
        });
        event.target.classList.add('hidden');
        const showLessBtn = slotsContainer.querySelector('.show-less-btn');
        showLessBtn.classList.remove('hidden');
      } else if (event.target.classList.contains('show-less-btn')) {
        const slotsContainer = event.target.parentNode;
        const allSlots = slotsContainer.querySelectorAll('.slot');
        const hiddenSlots = slotsContainer.querySelectorAll('.hidden');
        hiddenSlots.forEach((slot) => {
          slot.classList.remove('hidden');
        });
        allSlots.forEach((slot, index) => {
          if (index >= 3) {
            slot.classList.add('hidden');
          }
        });
        event.target.classList.add('hidden');
        const showMoreBtn = slotsContainer.querySelector('.show-more-btn');
        showMoreBtn.classList.remove('hidden');
      }
    });

    const leftArrow = calendarDays.parentElement.querySelector('.arrow-left');
    const rightArrow = calendarDays.parentElement.querySelector('.arrow-right');
    const daysToShow = 5;

    const updateCalendarDays = (currentDay, calendarDays) => {
      const startDate = new Date();
      startDate.setDate(startDate.getDate() + 2); // Start from two days after today

      const adjustedCurrentDay = currentDay >= 0 ? currentDay : currentDay + 1;

      const newStartDate = new Date(startDate);
      newStartDate.setDate(startDate.getDate() + adjustedCurrentDay);

      calendarDays.innerHTML = generateDaysHTML(adjustedCurrentDay, newStartDate);
      const newChosenSlots = document.querySelectorAll('.calendre_availabile_day_slot');
      newChosenSlots.forEach(slot => {
        slot.addEventListener('click', () => {
          newChosenSlots.forEach(slot => {
            slot.style.backgroundColor = '#E61F57';
            slot.style.color = 'white';
          });
          slot.style.backgroundColor = '#46807F';
          slot.style.color = 'white';
          const time = slot.textContent.trim();
          const rdvTime = document.getElementById('rdv_time');
          rdvTime.value = time;

          const slotDate = new Date(slot.getAttribute('data-date'));
          const currentYear = new Date().getFullYear();
          slotDate.setFullYear(currentYear);
          const rdvDate = document.getElementById('rdv_date');
          rdvDate.value = slotDate.toISOString().slice(0, 10);

          const formattedDate = slotDate.toLocaleString('en-US', {
            weekday: 'long',
            day: 'numeric',
            month: 'long',
            year: 'numeric'
          });
          const combinedDateTime = `${formattedDate} on ${time}`;

          const progressionTimes = document.querySelectorAll('.date_and_time');
          const selectedTimes = document.querySelectorAll('.type_rendez-vous_type_containe_confirmation_p');

          selectedTimes.forEach(selectedTime => {
            selectedTime.textContent = "you selected the " + combinedDateTime;
          });

          progressionTimes.forEach(progressionTime => {
            progressionTime.parentElement.parentElement.classList.remove('none');
            progressionTime.textContent = combinedDateTime;
          });
        });
      });
    };

    leftArrow.addEventListener('click', () => {
      if (currentDay > 0) {
        currentDay -= daysToShow;
        updateCalendarDays(currentDay, calendarDays);
      }
    });

    rightArrow.addEventListener('click', () => {
      currentDay += daysToShow;
      updateCalendarDays(currentDay, calendarDays);
    });

    const checkMediaQuery = () => {
      if (window.matchMedia('(max-width: 750px)').matches) {
        $(".criter_list").addClass('none');
      } else {
        $(".criter_list").removeClass('none');
      }
    }

    updateCalendarDays(currentDay, calendarDays);
    checkMediaQuery();
    window.addEventListener('resize', checkMediaQuery);
  });
}

// Call the function to initialize the appointment time slot functionality


 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  const input = document.getElementById('selected_input_analyse');
  const checkboxes2 = document.querySelectorAll('input[type=checkbox]');
  const container = document.querySelector('.element-selected-container');
  
  // Add event listener to each checkbox
  checkboxes2.forEach((checkbox) => {
    checkbox.addEventListener('change', () => {
      if (checkbox.checked) {
        const value = checkbox.value;
        const tag = document.createElement('span');
        tag.classList.add('element_selected');
        const tagValue = document.createElement('span');
        tagValue.classList.add('element_selected_value');
        tagValue.innerText = value;
        const tagClear = document.createElement('span');
        tagClear.classList.add('element_selected_delet_button', 'material-symbols-outlined');
        tagClear.style.fontSize = '18px';
        tagClear.innerText = 'close';
        tagClear.addEventListener('click', () => {
          container.removeChild(tag);
          input.value = input.value.split('$').filter(v => v !== value).join('$');
        });
        tag.appendChild(tagValue);
        tag.appendChild(tagClear);
        container.appendChild(tag);
        input.value += `${value}$`;
      } else {
        const tags = container.querySelectorAll('.element_selected');
        tags.forEach((tag) => {
          if (tag.querySelector('.element_selected_value').innerText === checkbox.value) {
            container.removeChild(tag);
            input.value = input.value.split('$').filter(v => v !== checkbox.value).join('$');
          }
        });
      }
    });
  });
  
  
  
  
  
  
  
  
  
  
  
  const element = document.getElementById('Book_Appointment_etape1');
  if (element !== null) {
      element.addEventListener('click', send_info_carte1);
  }
  
  function send_info_carte1() {
    console.log('send_info_carte function called'); // Added log message
  
    const progressionInfoNames = document.querySelectorAll('.progression_info_general_side_name');
    const progressionLieus = document.querySelectorAll('.lieu');
    const title = document.querySelector('.carte_laboratiore_profile-info_title').textContent;
    const city = document.querySelector('.carte_laboratiore_profile-place_city').textContent;
    const rue = document.querySelector('.carte_laboratiore_profile-place_rue').textContent;
    const address = `${city}, ${rue}`;
  
    progressionInfoNames.forEach(progressionInfoName => {
      progressionInfoName.textContent = title;
    });
  
    progressionLieus.forEach(progressionLieu => {
      progressionLieu.textContent = address;
    });
  }
  
  
  function send_info_carte(event) {
    const progressionLieus = document.querySelectorAll('.lieu');
    const contenu = event.target.textContent.trim();
    const city = document.querySelector('.carte_laboratiore_profile-place_city').textContent;
    const rue = document.querySelector('.carte_laboratiore_profile-place_rue').textContent;
    const address = `${city}, ${rue}`;
    let rdv_type= document.getElementById("rdv_type");
      
  
  
    progressionLieus.forEach(progressionLieu => {
      progressionLieu.parentElement.parentElement.classList.remove('none');
      if (contenu === "in the laboratory") {
        
    rdv_type.value = contenu ;
        progressionLieu.textContent = address;
      } else if (contenu === "at home") {
        
    rdv_type.value = contenu ;
        progressionLieu.textContent = 'at your house';
      }
    });
  }
  
  
  
  function send_analyse_type_info(event) {
    const progressionLieus = document.querySelectorAll('.visite_purpose');
    const motif_selecteds = document.querySelectorAll('.motif_selected');
    const contenu = event.target.textContent.trim();
    let rdv_purpose = document.getElementById("rdv_purpose");
  
    progressionLieus.forEach(progressionLieu => {
      progressionLieu.parentElement.parentElement.classList.remove('none');
      if (contenu === "blood test") {
        progressionLieu.textContent = contenu;
      } else if (contenu === "blood donation") {
        progressionLieu.textContent = 'At Your House';
      }
    });
  
    motif_selecteds.forEach(motif_selected => {
      motif_selected.textContent = contenu;
    });
  
    rdv_purpose.value = contenu;
  }
  
  













  





function performSearch() {
  var searchTerm = document.querySelector('#search-orders').value.trim().toLowerCase(); // Get the search term from the input field and remove leading/trailing spaces

  // Check if the search term is not empty
  if (searchTerm !== '') {
    // Get all the dl-search-result divs
    var searchResults = document.querySelectorAll('.carte_laboratiore');

    // Loop through each search result
    searchResults.forEach(function(result) {
      var codeZipInput = result.querySelector('input[name="code_postal"]'); // Get the code_zip input field within the search result

      if (codeZipInput && codeZipInput.value.trim().toLowerCase() === searchTerm) {
        result.classList.remove('none')  // Display the search result div if the code_zip matches the search term
      } else {
        result.classList.add('none')  // Hide the search result div if the code_zip does not match the search term
      }
    });
  } else {
    // If the search term is empty, display all search result divs
    var searchResults = document.querySelectorAll('.carte_laboratiore');
    searchResults.forEach(function(result) {
      result.classList.remove('none') 
    });
  }
}