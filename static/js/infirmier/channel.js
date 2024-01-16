function init(){
  
    const savedChannel = JSON.parse(localStorage.getItem('selectedChannel'));
    
        // to be displayed on the console, to be sure that the JS code is running
        console.log("App is initialized")
        
        // get existing channels from mock file or database
        
    
        // get existing messages from mock file or database
        
        // load the messages from messages.js into the channels
    
        // display the channels
      displayChannels();
    //   showMessages();
    
       
    }

    function displayChannels() {
        const regularElement = document.getElementById('messages_dashboard');
        let s = 1;
        regularElement.innerHTML = "";
        let channels;

      $.ajax({
        url: '/infirmier/channels-data/',  // Replace with the actual URL for your Django view
        type: 'GET',
        dataType: 'json',
        async: false,
        success: function(data) {
          channels = data;
        },
        error: function(xhr, status, error) {
          console.error('Error:', error);
          channels = [];  // Provide a default value or handle the error case
        }
      })
      console.log(channels)
        channels.forEach(channel => {
          const newDiv = document.createElement("div");
          newDiv.setAttribute("id", channel.id);
          newDiv.setAttribute("class", "message_dashboard");
          newDiv.setAttribute("onclick", `switchChannel('${channel.id}')`);
          newDiv.innerHTML = `
            <div class="message_dashboard_pic-profile">
              <ins class="initials initials--big" style="background-color: rgb(15, 46, 76);">
              ${channel.name.charAt(0)}${channel.name.split(" ")[1]?.charAt(0) || ''}
              </ins>
            </div>
            <div class="message_dashboard_discution">
              <p><strong>${channel.name}</strong></p>
              <p><small>${channel.sender ? "You" : "laboratory"}</small></p>
            </div>
            <div class="message_dashboard_time_date">
              <p><small>${channel.latestMessage}</small></p>
            </div>
          `;
          regularElement.appendChild(newDiv);
          s++;
        });
      }
      
      function switchChannel(channelId) {
        // Construct the URL based on the channel ID
        const url = '/infirmier/channels_inf/messages/' + channelId+'/'; // Replace '/your-url/' with the desired URL
      
        // Navigate to the URL
        window.location.href = url;
      }