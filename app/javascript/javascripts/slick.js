$(document).on('turbolinks:load', function() {
  if ($('.thumbnail').length >= 2) {
    $('.slider').slick({
      dots: true,
      centerMode: true,
      centerPadding: '10%',
      slidesToShow: 1,
      responsive: [
        {
          breakpoint: 576,
          settings: {
            arrows: false,
            centerMode: true,
            centerPadding: '5%',
            slidesToShow: 1
          }
        }
      ]
    });
  }
});
