
const sendButton = document.querySelector('#button_send');
const messagesScreen = document.querySelector('#messages_screen');






function   open_message_panel() {  
    $("#discution_panel").css('transform' ,"scale(1)");
    $("#discution_panel").removeClass('none');
    $("#messages_dashboard").addClass('none');
    $("#messages_dashboard").css('transform' ,"scale(0)");
   
    console.log(" notification info open ") ;
};
    function back_to_messages_dashboard() {  
    $("#discution_panel").css('transform' ,"scale(0)");
    $("#discution_panel").addClass('none');
    $("#messages_dashboard").removeClass('none');
    $("#messages_dashboard").css('transform' ,"scale(1)");
    console.log(" notification info closed ") ;
    };
    
    




    /** create global variable for the currently selected channel */
let selectedChannel;

// Functions to execute when DOM has loaded
function init(){
const savedChannel = JSON.parse(localStorage.getItem('selectedChannel'));

    // to be displayed on the console, to be sure that the JS code is running
    console.log("App is initialized")
    
    // get existing channels from mock file or database
    channels = mockChannels;

    // get existing messages from mock file or database
    messages = mockMessages;
    
    // load the messages from messages.js into the channels
    loadMessagesIntoChannel();

    // display the channels
  displayChannels();
  showMessages();
    if (savedChannel) {
    selectedChannel = savedChannel;
  }
   
}
//---------------- Channels-----------------------------------

// load existing messages into respective channel
function loadMessagesIntoChannel() {
channels.forEach(channel=> {
  let x=0;
messages.forEach(message=>{
if(message.channel===channel.id){
channel.messages[x]=message;
x++;
}
})
})
}


    

function displayChannels() {
  const regularElement = document.getElementById('messages_dashboard');
  let s = 1;
  regularElement.innerHTML = "";

  channels.forEach(channel => {
    const newDiv = document.createElement("div");
    newDiv.setAttribute("id", channel.id);
    newDiv.setAttribute("class", "message_dashboard");
    newDiv.setAttribute("onclick", "switchChannel(" + s + ")");
    newDiv.innerHTML = `
      <div class="message_dashboard_pic-profile">
        <ins class="initials initials--big" style="background-color: rgb(15, 46, 76);">
          ae
        </ins>
      </div>
      <div class="message_dashboard_discution">
        <p><strong>${channel.name}</strong></p>
        <p><small>You</small></p>
      </div>
      <div class="message_dashboard_time_date">
        <p><small>${channel.latestMessage}</small></p>
      </div>
    `;
    regularElement.appendChild(newDiv);
    s++;
  });
}



// changes header name and favorite button
function showHeader() {
    // Write your code here
    document.getElementById("profile-link__user").innerHTML =""+selectedChannel.name;
}
//click entre 




function switchChannel(selectedChannelID) {
 
   
    channels.forEach(channel => {
        if (channel.id === channels[selectedChannelID-1].id) {
          selectedChannel = channel;
          
        }
    })
  localStorage.setItem('selectedChannel', JSON.stringify(selectedChannel));
  
    showHeader();
  open_message_panel();
  showMessages();
}



 


//Add an EventListener for the HTML element "send-button" once it's clicked call the Java Script method: "sendMessage"
document.getElementById('button_send').addEventListener('click', sendMessage);

 const myElement = document.getElementById('button_send');
const user_name = myElement.dataset.user;


//---------------- Messages-----------------------------------

//Create a Message as an object
function Message(user, own, text, channelID) {
    
    this.createdBy = user; //username
    this.createdOn = new Date(Date.now()); // get the actual time
    this.own = own; 
    this.text = text; // get the text
    this.channel = channelID; // get the channel ID
}


function sendMessage() {
    const text = document.getElementById('message-input').value;

   // time channel

time=new Date();
 selectedChannel.latestMessage=time.getHours()+":"+time.getMinutes();


    // run the code only if the user has entred an message 
    if (!!text) {
        const myUserName = user_name;
        const own = true;
        const channelID = selectedChannel.id;
        const message = new Message(myUserName, own, text, channelID)
        console.log("New message: ", message);
        selectedChannel.messages.push(message);
        document.getElementById('message-input').value = '';
      showMessages();
        // scroll to the bottom of the message screen
  messagesScreen.scrollTo(0, messagesScreen.scrollHeight);


    } else {
        return // in cas the user hasen't entered any message and clicked on send
    }
}
function showMessages() {
    const chatArea = document.getElementById('messages_screen');
    chatArea.innerHTML = "";
    let messagesHtmlString = "";

    selectedChannel.messages.forEach(message => {
        const messageTime = message.createdOn.toLocaleTimeString("de-DE", {
            hour: "numeric",
            minute: "numeric"
        });
        if (message.own) {
            messagesHtmlString += `<div class="message_screen outgoing-message_screen">
                                        <div class="message-wrapper_screen">
                                            <div class="message-content_screen">
                                                <p>` + message.text + `</p>
                                            </div>
                                            <i class="material-icons">account_circle</i>
                                        </div>
                                        <span class="timestamp">` + messageTime + `</span>
                                    </div>`;
        } else {
            messagesHtmlString += `<div class="message_screen incoming-message_screen">
                                        <div class="message-wrapper_screen">
                                            <i class="material-icons">account_circle</i>
                                            <div class="message-content_screen">
                                                <h3>` + message.createdBy + `</h3>
                                                <p>` + message.text + `</p>
                                            </div>
                                        </div>
                                        <span class="timestamp">` + messageTime + `</span>
                                    </div>`;
        }
    });

    chatArea.innerHTML = messagesHtmlString;
}


const inputField = document.getElementById('message-input');

inputField.addEventListener("keyup", function(event) {
  if (event.keyCode === 13) {  // 13 is the code for the "Enter" key
    myElement.click();  // simulate a click on the send button
  }
});