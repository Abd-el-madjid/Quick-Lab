function init() {

    switchInput.dispatchEvent(new Event("change"));
         
    }
    
    
    

    
    
    
    
    
    
    
    function   Submit_change__personal_details(){
        let Save_Changes_personal_details_submit = document.getElementById("Save_Changes_personal_details_submit");
        Save_Changes_personal_details_submit.click();
    }
    
    function   Submit_change__profile_details(){
        let Save_Changes_personal_details_submit = document.getElementById("Save_Changes_personal_details_submit");
        Save_Changes_personal_details_submit.click();
    }
    
    function hide() {
        if ($(".icon-fill").css('opacity')==="1") {
            $(".icon-fill").css('opacity','0'); 
            show_password();
            $(".icon-outline").css('opacity','1');
           
        } else if($(".icon-outline").css('opacity')==="1") {
            show_password();
           
            
            $(".icon-fill").css('opacity','1');
            
        }
        d2.style.opacity = '0'
      }
    const icon_view = document.getElementsByClassName('icon-fill');
    
    
    
    function   open_preferences_panel() {  
        $("#panel-3").css('transform' ,"scale(1)");
        $("#panel-3").removeClass('none');
        $("#tab-3").addClass('RRT__tab--first');
        $("#tab-3").addClass('RRT__tab--selected');
        close_Account_details_panel();
        close_Personal_details_panel();
        close_update();
        console.log(" notification info open ") ;
    }; 
    
    function   close_preferences_panel() {  
        $("#panel-3").css('transform' ,"scale(0)");
        $("#panel-3").addClass('none');
        $("#tab-3").removeClass('RRT__tab--first');
        $("#tab-3").removeClass('RRT__tab--selected');
        
        console.log(" notification info open ") ;
    };
    
    function   open_Personal_details_panel() {  
        $("#panel-1").css('transform' ,"scale(1)");
        $("#panel-1").removeClass('none');
        $("#tab-1").addClass('RRT__tab--first');
        $("#tab-1").addClass('RRT__tab--selected');
        close_Account_details_panel();
        close_preferences_panel();
        close_update();
        console.log(" notification info open ") ;
    };
    
    function   close_Personal_details_panel() {  
        $("#panel-1").css('transform' ,"scale(0)");
        $("#panel-1").addClass('none');
        $("#tab-1").removeClass('RRT__tab--first');
        $("#tab-1").removeClass('RRT__tab--selected');
        
        console.log(" notification info open ") ;
    };
    
        function open_Account_details_panel() {  
            $("#panel-0").css('transform' ,"scale(1)");
            $("#panel-0").removeClass('none');
            $("#tab-0").addClass('RRT__tab--first');
            $("#tab-0").addClass('RRT__tab--selected');
            close_Personal_details_panel();
            close_preferences_panel();
            close_update();
            console.log(" notification info open ") ;
        };
        
        
        function   close_Account_details_panel() {  
            $("#panel-0").css('transform' ,"scale(0)");
            $("#panel-0").addClass('none');
            $("#tab-0").removeClass('RRT__tab--first');
            $("#tab-0").removeClass('RRT__tab--selected');
            
            console.log(" notification info open ") ;
        };
    
     
    
    
    
    
        function close_update(){
            $("#overlay-update-information").removeClass('ui-kit-overlay-visible');
           $("#overlay-update-password").removeClass('ui-kit-overlay-visible');
           $("#overlay-delet-account").removeClass('ui-kit-overlay-visible');
           $("#overlay-Update-personal-details").removeClass('ui-kit-overlay-visible');
        }
        function open_update_info_form(){
            $("#overlay-update-information").addClass('ui-kit-overlay-visible');
      
        }
        function open_update_info_password(){
            $("#overlay-update-password").addClass('ui-kit-overlay-visible');
      
        }
        function open_delet_account(){
            $("#overlay-delet-account").addClass('ui-kit-overlay-visible');
      
        }
        function open_Update_personal_details(){
            $("#overlay-Update-personal-details").addClass('ui-kit-overlay-visible');
      
        }
    
           /**      jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj */
              /**      jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj */
                 /**      jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj */
        /**      jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj */
    
        function show_password(){
    if ( $(".icon-outline").css('opacity')==="1") {  $('#passwordErrorMessage').attr('type', 'text');
    $(".icon-outline").css('opacity','0');
    $(".icon-fill").css('opacity','1');
       
    } else if ( $(".icon-outline").css('opacity')==="0"){
        $('#passwordErrorMessage').attr('type', 'password');
        $(".icon-outline").css('opacity','1');
        $(".icon-fill").css('opacity','0');
    }
        }
    
        function show_password1(){
            if ( $(".icon-outline1").css('opacity')==="1") {  $('#currentPassword').attr('type', 'text');
            $(".icon-outline1").css('opacity','0');
            $(".icon-fill1").css('opacity','1');
               
            } else if ( $(".icon-outline1").css('opacity')==="0"){
                $('#currentPassword').attr('type', 'password');
                $(".icon-outline1").css('opacity','1');
                $(".icon-fill1").css('opacity','0');
            }
                }
                function show_password2(){
                    if ( $(".icon-outline2").css('opacity')==="1") {  $('#newPassword').attr('type', 'text');
                    $(".icon-outline2").css('opacity','0');
                    $(".icon-fill2").css('opacity','1');
                       
                    } else if ( $(".icon-outline2").css('opacity')==="0"){
                        $('#newPassword').attr('type', 'password');
                        $(".icon-outline2").css('opacity','1');
                        $(".icon-fill2").css('opacity','0');
                    }
                        }
                        function show_password3(){
                            if ( $(".icon-outline3").css('opacity')==="1") {  $('#newPasswordConfirm').attr('type', 'text');
                            $(".icon-outline3").css('opacity','0');
                            $(".icon-fill3").css('opacity','1');
                               
                            } else if ( $(".icon-outline3").css('opacity')==="0"){
                                $('#newPasswordConfirm').attr('type', 'password');
                                $(".icon-outline3").css('opacity','1');
                                $(".icon-fill3").css('opacity','0');
                            }
                                }
    
      /**      jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj */
         /**      jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj */
            /**      jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj */
               /**      jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj */
        
        $(document).ready(function(){
        
       
        $(document).on('click', '#tab-1',  open_Personal_details_panel );
        
        $(document).on('click', '.close_2',  open_Personal_details_panel );
        
        $(document).on('click', '#tab-0',  open_Account_details_panel );
        $(document).on('click', '#tab-3',  open_preferences_panel );
        
        $(document).on('click', '#overlay-close',  close_update);
    
        $(document).on('click', '#overlay-background',  close_update );
    
        $(document).on('click', '#Update_sign',  open_update_info_form );
    
        $(document).on('click', '#Change_password',  open_update_info_password );
    
        $(document).on('click', '#delet_account',  open_delet_account );
    
        $(document).on('click', '#Update_personal_details',  open_Update_personal_details );
        }); 
        
    
    
    
    
    
        var switchInput = document.getElementById("appointmentReminders");
        var dataEtat = switchInput.parentNode.getAttribute("data-etat");
    
        if (dataEtat === "True") {
            switchInput.checked = true;
        } else {
            switchInput.checked = false;
        }
    
        switchInput.addEventListener("change", function() {
            if (switchInput.checked) {
                switchInput.parentNode.setAttribute("data-etat", "True");
            } else {
                switchInput.parentNode.setAttribute("data-etat", "False");
            }
    
            // Optional: Log the updated value of data-etat
            console.log("Updated data-etat:", switchInput.parentNode.getAttribute("data-etat"));
        });
    
function submit_two_fact(){
    console.log("im hee")
    var form = document.querySelector('.two_fact');
    var formData = new FormData(form);

    fetch(form.action, {
        method: 'POST',
        body: formData
    })
    .then(response => {
        // Handle the response
    })
    .catch(error => {
        // Handle any errors
    });
}