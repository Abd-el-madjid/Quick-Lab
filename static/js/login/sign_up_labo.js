$('#leftArrow').on('click', function() {
    $('#mySlider').slick('slickPrev');
});

$('#rightArrow').on('click', function() {
    $('#mySlider').slick('slickNext');
});







$(document).ready(function () {


      





                $('.vertical_tabs__nav-item-adfdw').click(function() {
                var index = $(this).index();

                $('.vertical_tabs__nav-item-adfdw').removeClass('is-active-dNmCb');
                $(this).addClass('is-active-dNmCb');

                $('.vertical_tabs__content-wrapper-S8g2o').addClass('none');
                $('.vertical_tabs__content-wrapper-S8g2o:eq(' + index + ')').removeClass('none');
                });
    
    var contents = $('.vcarousel__content .vcarousel__content_item');
    var menuItems = $('.vcarousel__menu_contents .item');

    menuItems.each(function(index) {
        $(this).click(function() {
            selectMenuItem(index);
        });
    });

    // Automatic switching every 10 seconds
    var autoIndex = 0;
    setInterval(function() {
        selectMenuItem(autoIndex);
        autoIndex = (autoIndex + 1) % menuItems.length; // Go to the next index, wrap around if at the end
    }, 5000); // 10000 milliseconds = 10 seconds
});

function selectMenuItem(index) {
    var contents = $('.vcarousel__content .vcarousel__content_item');
    var menuItems = $('.vcarousel__menu_contents .item');

    menuItems.find('h4').removeClass('text-pink'); // remove pink class from all h4 elements
    menuItems.eq(index).find('h4').addClass('text-pink'); // add pink class to clicked h4 element
    
    contents.addClass('hidden'); // hide all content items
    contents.eq(index).removeClass('hidden'); // show corresponding content item

    // Adjust the top property of the indicator
    var newTop = index * 48; // Multiply the index by 48 to get the new top value
    $('.vcarousel__menu_bar_indicator').css('top', newTop + 'px'); // Apply the new top value
}










