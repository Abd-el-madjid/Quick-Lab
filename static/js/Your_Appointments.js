function filterByDate() {
  // Get the input date from the search bar
  const inputDate = new Date(document.querySelector('#date_search_bar_input').value);


  // Loop through all the rendez-vous elements
  const rendezVousElements = document.querySelectorAll('.rendez-vous');
  rendezVousElements.forEach((rvElement) => {
    // Extract the date value from the rendez-vous element
    const rdvDateText = rvElement.querySelector('.rdv_date').textContent.trim();
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
   const matchingRows = document.querySelectorAll("#rendez-vous_container:not(.none)");
   const emptyResultatContainer = document.querySelector(".empty_resultat_container");
   if (matchingRows.length === 0) {
     // Show the empty result container
     emptyResultatContainer.classList.remove("none");
 
   } else {
     // Hide the empty result container
     emptyResultatContainer.classList.add("none");
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


function   show_QR() {  
  $("#QR_code").toggleClass('none');
 
 
  console.log(" date_search_bar_container info open ") ;
};
function   show_conseign() {  
  $("#conseign").toggleClass('none');
 
 
  console.log(" date_search_bar_container info open ") ;
};

function   modifier_button_rdv() {  
  $("#modifie_rdv_form").toggleClass('none');
 
 
  console.log(" date_search_bar_container info open ") ;
};
function   delet_button_rdv() {  
  $("#delet_rdv_form").toggleClass('none');
 
 
  console.log(" date_search_bar_container info open ") ;
};
function   open_search_date_panel() {  
  $("#date_search_bar_container").toggleClass('none');
 
 
  console.log(" date_search_bar_container info open ") ;
};
  function close_search_date_panel() {  
  $("#date_search_bar_container").css('transform' ,"scale(0)");
  $("#date_search_bar_container").addClass('none');

  console.log(" date_search_bar_container info closed ") ;
  };
  
  function open_rdv_detaille() {  
      $("#rdvs_container").css('transform' ,"scale(0)");
      $("#rdvs_container").addClass('none');

      $("#rdv_detaille_container").css('transform' ,"scale(1)");
      $(".rdv_detaille_container").removeClass('none');
  
      console.log(" rdv_detaille_container info open ") ;
      };
  
      mobiscroll.setOptions({
          locale: mobiscroll.localeAr,
          theme: 'ios',
          themeVariant: 'light'
      });
      
      mobiscroll.select('#demo-multiple-select', {
          inputElement: document.getElementById('demo-multiple-select-input')
      });
  $(document).ready(function(){
  
  
  
  
  $(document).on('click', '#rendez-vous',  open_rdv_detaille);
  
  }); 
  
  
function init() {


appointment_time_slot();
}  
  
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
      calendarDays.innerHTML = generateDaysHTML(currentDay);
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
          rdvDate.value = slotDate.toISOString().slice(0,10);
  
  
  // Format the date as "Thursday, March 2, 2023"
  const formattedDate = slotDate.toLocaleString('en-US', {
   
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  });
  // Combine the date and time in the desired format
  const combinedDateTime = `${formattedDate} on ${time}`;
  
  
  const selectedTimes = document.querySelectorAll('.p_date_time');
  
  selectedTimes.forEach(selectedTime => {
    selectedTime.textContent = "the  " + combinedDateTime;
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
};

