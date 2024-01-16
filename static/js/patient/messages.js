
// const sendButton = document.querySelector('#button_send');
const messagesScreen = document.querySelector('#messages_screen');
let isFirstLoad = true; // Flag to track the first load
let isScrolledToBottom = true;






    function back_to_messages_dashboard() {  
      const url = '/patient/channels_patient/'; // Replace '/your-url/' with the desired URL

      // Navigate to the URL
      window.location.href = url;
    };
    
    




    /** create global variable for the currently selected channel */
// let selectedChannel;
let messages ;
let hiddenValue;
// Functions to execute when DOM has loaded
function init(){
  let myElement= document.getElementById('button_send');
  let inputField = document.getElementById('message-input');
inputField.addEventListener("keyup", function(event) {
  if (event.keyCode === 13) {  // 13 is the code for the "Enter" key
    myElement.click();  // simulate a click on the send button
  }
});


  const hiddenInput = document.getElementById("hiddenInput");
  hiddenValue = hiddenInput.value;
    
    // get existing messages from mock file or database
    
    
    // loadMessagesIntoChannel();


  showMessages();

  // messagesScreen.scrollTo(0, messagesScreen.scrollHeight);

}


//---------------- Channels-----------------------------------

// load existing messages into respective channel
function loadMessagesIntoChannel() {
  let x=0;
messages.forEach(message=>{

messages[x]=message;
x++;
})
}




    



// // changes header name and favorite button
// function showHeader() {
//     // Write your code here
//     document.getElementById("profile-link__user").innerHTML =""+selectedChannel.name;
// }
// //click entre 




// function switchChannel(selectedChannelID) {
 
   
//     channels.forEach(channel => {
//         if (channel.id === channels[selectedChannelID-1].id) {
//           selectedChannel = channel;
          
//         }
//     })
//   localStorage.setItem('selectedChannel', JSON.stringify(selectedChannel));
  
//     showHeader();
//   open_message_panel();
//   showMessages();
// }



 


//Add an EventListener for the HTML element "send-button" once it's clicked call the Java Script method: "sendMessage"
// document.getElementById('button_send').addEventListener('click', sendMessage);


// const user_name = myElement.dataset.user;


// //---------------- Messages-----------------------------------

// Create a Message as an object
function Message(user, own, text, channelID) {
    var currentDate = new Date();
    this.createdBy = user; //username
    console.log(new Date(currentDate.toLocaleString('en-US', { timeZone: 'Africa/Algiers' })));
    this.createdOn = new Date(currentDate.toLocaleString('en-US', { timeZone: 'Africa/Algiers' })); // get the actual time
    this.own = own; 
    this.text = text; // get the text
    this.channel = channelID; // get the channel ID
}


function sendMessage() {
    const text = document.getElementById('message-input').value;

   // time channel
    
    time=new Date();
    latestMessage=time.getHours()+":"+time.getMinutes();
    
    // run the code only if the user has entred an message 
    if (!!text) {
      
        const myUserName = "zaki";
        const own = true;
        const channelID = hiddenValue;
        const message = new Message(myUserName, own, text, channelID)
        console.log("New message: ", message);
        messages.push(message);
        document.getElementById('message-input').value = '';
      showMessages();
        // scroll to the bottom of the message screen
      

      var formData = {
        message : text
      };
      const hiddenInput = document.getElementById("hiddenInput");
      hiddenValue = hiddenInput.value;

      $.ajax({
        url: '/patient/channels_patient/messages/' + hiddenValue + '/',
        type: 'POST',
        headers: {
          'X-CSRFToken': getCookie('csrftoken')
        },
        data: formData,
        success: function(response) {
          console.log(response);
        },
        error: function(xhr) {
          console.log(xhr.responseText);
        }
      });

      // messagesScreen.scrollTo(0, messagesScreen.scrollHeight);

    } else {
        return // in cas the user hasen't entered any message and clicked on send
    } 



}



function showMessages() {
  const chatArea = document.getElementById('messages_screen');
  chatArea.innerHTML = "";

  let messagesHtmlString = "";


  $.ajax({
    url: '/patient/messages_data/'+ hiddenValue +'/',  // Replace with the actual URL for your Django view
    type: 'GET',
    dataType: 'json',
    async: false,
    success: function(data) {
      messages = data;
    },
    error: function(xhr, status, error) {
      console.error('Error:', error);
      messages = [];  // Provide a default value or handle the error case
    }
  });
  messages.forEach(message => {
    const createdOnDate = new Date(message.createdOn);
    const messageTime = createdOnDate.toLocaleTimeString("en-US", {
      hour: "numeric",
      minute: "numeric"
    });

    if (message.own) {
      messagesHtmlString += `<div class="message_screen outgoing-message_screen">
                                <div class="message-wrapper_screen">
                                    <div class="message-content_screen">
                                        <p>${message.text}</p>
                                    </div>
                                    <span class="material-symbols-outlined" style="  font-variation-settings:
                                    'FILL' 1,
                                    'wght' 400,
                                    'GRAD' 0,
                                    'opsz' 48;">
account_circle
</span>
                                </div>
                                <span class="timestamp">${messageTime}</span>
                              </div>`;
    } else {
      messagesHtmlString += `<div class="message_screen incoming-message_screen">
                                <div class="message-wrapper_screen">
                                <span class="material-symbols-outlined" style="  font-variation-settings:
                                'FILL' 1,
                                'wght' 400,
                                'GRAD' 0,
                                'opsz' 48;">
account_circle
</span>
                                    <div class="message-content_screen">
                                        <p>${message.text}</p>
                                    </div>
                                </div>
                                <span class="timestamp">${messageTime}</span>
                              </div>`;
    }
  });
  
  chatArea.innerHTML = messagesHtmlString;
  if (isFirstLoad || isScrolledToBottom) {
    chatArea.scrollTo(0, chatArea.scrollHeight);
  }

  // Check if the chat area is scrolled to the bottom
  isScrolledToBottom = chatArea.scrollHeight - chatArea.clientHeight <= chatArea.scrollTop + 1;

  // Update the flag after the first load
  isFirstLoad = false;
}
function handleScroll() {
  const chatArea = document.getElementById('messages_screen');
  const isAtBottom = chatArea.scrollHeight - chatArea.clientHeight <= chatArea.scrollTop + 1;

  // Update the scroll state
  isScrolledToBottom = isAtBottom;
}

const chatArea = document.getElementById('messages_screen');
chatArea.addEventListener('scroll', handleScroll);

setInterval(showMessages, 2000);
// myElement.addEventListener('click', sendMessage);

function getCookie(name) {
  const cookieName = name + "=";
  const cookieArray = document.cookie.split(';');

  for (let i = 0; i < cookieArray.length; i++) {
    let cookie = cookieArray[i];
    while (cookie.charAt(0) === ' ') {
      cookie = cookie.substring(1);
    }
    if (cookie.indexOf(cookieName) === 0) {
      return cookie.substring(cookieName.length, cookie.length);
    }
  }
  return null;
}
