function init(){

    $(".menu-panel").removeClass('menu-panel-overlay--visible');
    $(".menu-panel-overlay").removeClass('menu-panel-overlay--visible');
    
   
    
    
    }
  
    function toggle_notification() {
      var is_open = $("#notification_panel").css('transform') === "matrix(1, 0, 0, 1, 0, 0)";
      
      if (is_open) {
        $("#notification_panel").css('transform' ,"scale(0)");
        console.log(" notification info closed ") ;
      } else {
        $("#notification_panel").css('transform' ,"scale(1)");
       
        close_main_account_profil();
        console.log(" notification info opened ") ;
      }
    }
    
    
    function toggle_side_account_profil() {
      var is_open = $(".side-account-profil").css('transform') === "matrix(1, 0, 0, 1, 0, 0)";
      
      if (is_open) {
        $(".side-account-profil").css('transform' ,"scale(0)");
        $(".side-account-profil").addClass('none');
        $(".side-menu ").removeClass('none');
        $(" #profile_head-secound").css('color' ,"#32325d");
        $(" #profile-arrow-2").css('position' ,"relative");
        $(" #profile-arrow-2").css('top' ,"0px");
        console.log(" profile info closed ") ;
      } else {
        $(".side-account-profil").css('transform' ,"scale(1)");
        $(".side-account-profil").removeClass('none');
        $(".side-menu ").addClass('none');
        $(" #profile_head-secound").css('color' ,"#46807F");
        $(" #profile-arrow-2").css('position' ,"relative");
        $(" #profile-arrow-2").css('top' ,"10px");
        console.log(" profile info opened ") ;
      }
    }
    
    
    function toggle_main_account_profil() {
      var is_open = $("#user-menu").css('transform') === "matrix(1, 0, 0, 1, 0, 0)";
      
      if (is_open) {
        $("#user-menu").css('transform' ,"scale(0)");
        $(" #profile_head-main").css('color' ,"#32325d");
        $(" #profile-arrow").css('top' ,"0px");
        console.log(" profile info closed ") ;
      } else {
        $("#user-menu").css('transform' ,"scale(1)");
        $(" #profile_head-main").css('color' ,"#46807F");
        $(" #profile-arrow").css('position' ,"relative");
        $(" #profile-arrow").css('top' ,"10px");
      
        close_notification(); 
        console.log(" profile info opened ") ;
      }
    }
    
    function close_notification() {  
      $("#notification_panel").css('transform' ,"scale(0)");
     
      
      console.log(" notification info closed ") ;
      }
      function close_main_account_profil() {  
        $("#user-menu").css('transform' ,"scale(0)");
        $(" #profile_head-main").css('color' ,"#32325d");
        $(" #profile-arrow").css('top' ,"0px");
        $("#user-menu").css('transform' ,"scale(0)");
        console.log(" profile info open ") ;
        }
    
    function open_side_menu()  {  
    $(".menu-panel").addClass('menu-panel-overlay--visible');
    $(".menu-panel-overlay").addClass('menu-panel-overlay--visible');
    
    console.log(" profile info open ") ;
    }
    function close_side_menu()  {  
    $(".menu-panel").removeClass('menu-panel-overlay--visible');
    $(".menu-panel-overlay").removeClass('menu-panel-overlay--visible');
    
    console.log(" profile info open ") ;
    }


    function help_request_form(){  
        $("#help_request_form").toggleClass('none');
       
       
        console.log(" date_search_bar_container info open ") ;
    };

    function toggleDropdown(element) {
        element.parentElement.classList.toggle('active');
      }



      function handleDropdown() {
        const button = event.target;
        const menu = button.parentNode.querySelector("#dropdown-menu_container");
      
        // toggle the show class to show/hide the dropdown
        menu.classList.toggle("show");
      
        // hide all other dropdowns
        const menus = document.querySelectorAll("#dropdown-menu_container");
        menus.forEach((dropdown) => {
          if (dropdown !== menu) {
            dropdown.classList.remove("show");
          }
        });
      
        // hide dropdown when clicking on a dropdown-item
        const dropdownItems = menu.querySelectorAll(".dropdown-item");
        dropdownItems.forEach((item) => {
          item.addEventListener("click", hideDropdown);
        });
      }
      
      function hideDropdown() {
        const menu = this.closest("#dropdown-menu_container");
        menu.classList.remove("show");
      }
      

      
      
      
    /**  ---------------------------------------------------------------------------------------- */
    /**  ---------------------------------------------------------------------------------------- */
    /**  ---------------------------------------------------------------------------------------- */
    /**  ---------------------------------------------------------------------------------------- */
    /**  ---------------------------------------------------------------------------------------- */
    /**  ---------------------------------------------------------------------------------------- */



    
$(document).ready(function(){
    
    
    
    $(document).on('click', '#notification',  toggle_notification);
    
    
    $(document).on('click', '#profile_head-secound',  toggle_side_account_profil);
    
    
    
    
    
    
    $(document).on('click', '#profile-info-1',toggle_main_account_profil);
    
    
    $(document).on('click', '#main_element', function() { 
      close_notification(); 
      close_main_account_profil();
    
    console.log(" profile info close ") ;
    });
    $(document).on('click', '#account-tabs', function() { 
        close_notification(); 
        close_main_account_profil();
        
        console.log(" profile info close ") ;
        });
    
    
    $(window).on('load scroll',function(){
    close_main_account_profil();
    close_notification();
    console.log(" profile info close ") ;
    
    var scrolled = $(this).scrollTop() > 5;
    });
    
    
    
    $(document).on('click', '#menu-link_button', function ()  {  
    open_side_menu();
    close_main_account_profil();
    close_notification();
    console.log(" profile info open ") ;
    });
    
    $(document).on('click', '.menu-panel-overlay', function() {  
    close_side_menu();
    close_side_account_profil();
    
    });
    
    
}); 
    
    
    
    