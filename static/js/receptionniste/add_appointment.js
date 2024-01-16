function init() {
            mobiscroll.setOptions({
            locale: mobiscroll.localeAr,
            theme: 'ios',
            themeVariant: 'light'
        });
        
        mobiscroll.select('#demo-multiple-select', {
            inputElement: document.getElementById('demo-multiple-select-input')
        });


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
      startDate.setDate(currentDate.getDate()); // Start from two days after today
    
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

    // const updateCalendarDays = (currentDay, calendarDays) => {
    //   const startDate = new Date();
    //   startDate.setDate(startDate.getDate() + 2); // Start from two days after today

    //   const adjustedCurrentDay = currentDay >= 0 ? currentDay : currentDay + 1;

    //   const newStartDate = new Date(startDate);
    //   newStartDate.setDate(startDate.getDate() + adjustedCurrentDay);

    //   calendarDays.innerHTML = generateDaysHTML(adjustedCurrentDay, newStartDate);
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
    //       rdvDate.value = slotDate.toISOString().slice(0, 10);

    //       const formattedDate = slotDate.toLocaleString('en-US', {
    //         weekday: 'long',
    //         day: 'numeric',
    //         month: 'long',
    //         year: 'numeric'
    //       });
    //       const combinedDateTime = `${formattedDate} on ${time}`;

    //       const progressionTimes = document.querySelectorAll('.date_and_time');
    //       const selectedTimes = document.querySelectorAll('.type_rendez-vous_type_containe_confirmation_p');

    //       selectedTimes.forEach(selectedTime => {
    //         selectedTime.textContent = "you selected the " + combinedDateTime;
    //       });

    //       progressionTimes.forEach(progressionTime => {
    //         progressionTime.parentElement.parentElement.classList.remove('none');
    //         progressionTime.textContent = combinedDateTime;
    //       });
    //     });
    //   });
    // };

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



let stream;
    let captureCount = 0;
    let isCameraStarted = false;

    // function startCamera() {
    //   if (!isCameraStarted) {
    //     const videoContainer = document.getElementById('videoContainer');
    //     const videoElement = document.createElement('video');
    //     videoElement.id = 'videoElement';
    //     videoElement.autoplay = true;

    //     videoContainer.appendChild(videoElement);

    //     if ('mediaDevices' in navigator && 'getUserMedia' in navigator.mediaDevices) {
    //       navigator.mediaDevices.getUserMedia({ video: true })
    //         .then(function(mediaStream) {
    //           stream = mediaStream;
    //           videoElement.srcObject = mediaStream;
    //         })
    //         .catch(function(error) {
    //           console.log('Error accessing camera:', error);
    //         });
    //     } else {
    //       console.log('getUserMedia is not supported');
    //     }

    //     isCameraStarted = true;
    //   }
    // }
    function startCamera() {
      if (!isCameraStarted) {
        const videoContainer = document.getElementById('videoContainer');
        const videoElement = document.createElement('video');
        videoElement.id = 'videoElement';
        videoElement.autoplay = true;
    
        videoContainer.appendChild(videoElement);
    
        
          const constraints = { video: { facingMode: "environment" } };
    
          navigator.mediaDevices.getUserMedia(constraints)
            .then(function(mediaStream) {
              stream = mediaStream;
              videoElement.srcObject = mediaStream;
            })
            .catch(function(error) {
              console.log('Error accessing camera:', error);
            });
       
    
        isCameraStarted = true;
      }
    }
    
    
    
    
    
    
    
    

    function captureImage() {
      const videoElement = document.getElementById('videoElement');

      if (videoElement && stream) {
        const canvasElement = document.createElement('canvas');
        const context = canvasElement.getContext('2d');
        
        canvasElement.width = videoElement.videoWidth;
        canvasElement.height = videoElement.videoHeight;
        
        context.drawImage(videoElement, 0, 0, canvasElement.width, canvasElement.height);
        
        const image = canvasElement.toDataURL('image/png');
        console.log('Captured image:', image);
        
        captureCount++;

        if (captureCount === 2) {
          stopCamera();
          captureCount = 0;
        }
      }
    }

    function stopCamera() {
      const videoElement = document.getElementById('videoElement');
      toggleForm();
      if (stream) {
        const tracks = stream.getTracks();
        tracks.forEach(function(track) {
          track.stop();
        });
      }
    
      if (videoElement) {
        videoElement.srcObject = null;
        videoElement.remove();
      }
      isCameraStarted = false;
    
      // Make an AJAX request to retrieve the data from the Django view
      var xhr = new XMLHttpRequest();
      xhr.open('GET', '/receptionniste/ocr', true);  // Modify the URL if needed
      xhr.onload = function() {
        if (xhr.status === 200) {
          var response = JSON.parse(xhr.responseText);
          // Retrieve the data from the response
          var id = response.id;
          var date = response.date;
          var groupage = response.groupage;
          var sex = response.sex;
          var place = response.place;
          var finame = response.finame;
          var laname = response.laname;
    
          // Fill the form fields with the retrieved data
          document.getElementById('id').value = id;
          document.getElementById('fname').value = finame;
          document.getElementById('lname').value = laname;
          document.getElementById('date_birth').value = date;
          document.getElementById('place_birth').value = place;
          
          var genderSelect = document.getElementById('gender');
          // Loop through options to set the selected value
          for (var i = 0; i < genderSelect.options.length; i++) {
            if (genderSelect.options[i].value === sex) {
              genderSelect.selectedIndex = i;
              break;
            }
          }
        } else {
          console.log('Request failed with status:', xhr.status);
        }
      };
      xhr.onerror = function() {
        console.log('Request failed');
      };
      xhr.send();
    }
    
    
    

    document.addEventListener('keydown', function(event) {
      if (event.key === 'Enter') {
        captureImage();
      }
    });
    let tapCount = 0;
const tapDelay = 300; // Adjust this value to set the maximum delay between taps (in milliseconds)

document.addEventListener('touchend', function(event) {
  tapCount++;
  if (tapCount === 1) {
    setTimeout(function() {
      if (tapCount === 1) {
        // Single tap, do nothing
      } else if (tapCount === 2) {
        // Double tap, capture image
        captureImage();
      }
      tapCount = 0;
    }, tapDelay);
  }
});


    function toggleForm() {
      const form_scanner = $("#form_scanner");
     
     
          form_scanner.toggleClass('none');
        console.log("add button clicked");
        const videoElement = document.getElementById('videoElement');
      if (stream) {
        const tracks = stream.getTracks();
        tracks.forEach(function(track) {
          track.stop();
        });
      }
    
      if (videoElement) {
        videoElement.srcObject = null;
        videoElement.remove();
      }
      isCameraStarted = false;
    
    }