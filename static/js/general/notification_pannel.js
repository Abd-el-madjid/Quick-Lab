

let Notifications;

// Functions to execute when DOM has loaded
function init(){


    // to be displayed on the console, to be sure that the JS code is running
    console.log("App is initialized");
    
    // get existing channels from mock file or database
   


    
  

    // display the channels
    displaynotification();

   
}
//---------------- Channels-----------------------------------



function displaynotification() {
  $.ajax({
    url: '/notification/',  // Replace with the actual URL for your Django view
    type: 'GET',
    dataType: 'json',
    async: false,
    success: function(data) {
      Notifications = data;
    },
    error: function(xhr, status, error) {
      console.error('Error:', error);
      Notifications = [];  // Provide a default value or handle the error case
    }
  });
  var notificationCount = 0; // Calculate the number of notifications
  
  const regularElement = document.getElementById('notification_dashboard');
  regularElement.innerHTML = "";

  
  Notifications.forEach(Notification => {
   if (Notification.etat === 0 ) {
     notificationCount += 1;
    // Check if the distination is the same as the patient ID
    const liElement = document.createElement('li');
    liElement.classList.add('bordered-block', 'notification');

    const notificationTypeElement = document.createElement('div');
    notificationTypeElement.classList.add('notification__type', 'notification__type--1');
    liElement.appendChild(notificationTypeElement);

    const notificationDataElement = document.createElement('div');
    notificationDataElement.classList.add('notification__data');
    liElement.appendChild(notificationDataElement);

    const notificationContent1 = document.createElement('div');
    notificationContent1.innerHTML = `
        <strong>${Notification.createdBy}</strong>
        ${Notification.text}
      `;
    notificationDataElement.appendChild(notificationContent1);

    const notificationContent2 = document.createElement('div');
    notificationContent2.classList.add('indent-top');
    const notificationLink = document.createElement('a');
    notificationLink.classList.add('text-style--bold');
    notificationLink.setAttribute('psimsg', 'alert.dismissAlert');
      
    notificationContent2.appendChild(notificationLink);
    notificationDataElement.appendChild(notificationContent2);

    const notificationHideElement = document.createElement('div');
    notificationHideElement.classList.add('notification__hide');
    const notificationHideIcon = document.createElement('span');
    notificationHideIcon.classList.add('material-symbols-outlined');

     
    notificationHideIcon.textContent = 'disabled_by_default';
    notificationHideElement.appendChild(notificationHideIcon);
    
    const notificationheaur = document.createElement('span');
    notificationheaur.textContent = Notification.createdOn;
    notificationDataElement.appendChild(notificationheaur);

    const notificationspace = document.createElement('span');
    notificationspace.textContent = '       --       ';
    notificationDataElement.appendChild(notificationspace);
    
    const notificationid = document.createElement('span');
    notificationid.textContent = Notification.id;
    notificationid.id = "notif_id";
    notificationDataElement.appendChild(notificationid);
    

    notificationHideElement.onclick = etat;
    liElement.appendChild(notificationHideElement);

    regularElement.appendChild(liElement);

   
   
  }
       });

   const notificationBubble = document.getElementById('notification-bubble');
  notificationBubble.textContent = notificationCount;
  console.log(`Total number of notifications: ${notificationCount}`);
}

function getCookie(name) {
  const cookieValue = document.cookie.match('(^|;)\\s*' + name + '\\s*=\\s*([^;]+)');
  return cookieValue ? cookieValue.pop() : '';
}


function etat() {
  console.log("hihihi");
  const notification_id = document.getElementById('notif_id').textContent;
  console.log("notification_id", notification_id);
const elementToRemove = this.parentElement;
  const formData = {
    id: notification_id
  };

  $.ajax({
    url: '/notification/',
    type: 'POST',
    headers: {
      'X-CSRFToken': getCookie('csrftoken')
    },
    data: formData,
    success: function (response) {
           elementToRemove.remove(); // Use the stored reference to remove the element
      displaynotification();
      console.log(response);
      
      // Additional actions on success
      // For example, display a success message or perform other tasks
      console.log("Notification marked as read");
          const notificationBubble = document.getElementById('notification-bubble');
      const currentCount = parseInt(notificationBubble.textContent);
      const newCount = currentCount - 1;
      notificationBubble.textContent = newCount;
      console.log(`Total number of notifications: ${newCount}`);
          
    },
    error: function(xhr) {
      console.log(xhr.responseText);
    }
  });

}



document.addEventListener('DOMContentLoaded', init);
