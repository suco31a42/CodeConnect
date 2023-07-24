// 無限スクロールの処理
$(document).on('turbolinks:load', function() {
  $('.jscroll').jscroll({
    contentSelector: '.scroll-list',
    nextSelector: 'span.next:last a',
  });
})