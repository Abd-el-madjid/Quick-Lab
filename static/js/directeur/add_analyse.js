function init(){ 


mobiscroll.setOptions({
    locale: mobiscroll.localeAr,
    theme: 'ios',
    themeVariant: 'light'
});

mobiscroll.select('#analyse_name_select', {
    inputElement: document.getElementById('analyse_name'),
    filter: true,
   
    onChange: function (event, inst) {
        // Logic for value change
    },
    onClose: function (event, inst) {
        // Your custom event handler goes here
    },
    onDestroy: function (event, inst) {
        // Your custom event handler goes here 
    },
    onFilter: function (event, inst) {
        // Your custom event handler goes here 
    },
    onInit: function (event, inst) {
        // Logic running on component init
    },
    onOpen: function (event, inst) {
        // Your custom event handler goes here 
    },
    onPosition: function (event, inst) {
        // Logic for component positioning
    },
    onTempChange: function (event, inst) {
        // Logic for temporary value change
    }
});}