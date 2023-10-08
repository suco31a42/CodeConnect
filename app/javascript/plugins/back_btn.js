$(function() {
  var back = $('#back');
  // 普段は消す
  back.hide();
  $(window).scroll(function () {
    // スクロールの値が500以上でフェードイン
    if ($(this).scrollTop() > 500) {
      back.fadeIn();
    } else {
      back.fadeOut();
    }
  });

  back.click(function (){
    $('body, html').animate({
      scrollTop:0
    }, 800);
    return false;
  });
});