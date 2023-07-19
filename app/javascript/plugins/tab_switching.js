$('#tab-menu a').on('click', function(event) {
  $("#tab-menu .active").removeClass(".active");
  $(this).addClass("active");
  $($(this).attr("href")).show();
  event.preventDefault();
})