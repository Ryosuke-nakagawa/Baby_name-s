$(function(){
    $('.js-modal-open').on('click',function(){
        var target = $(this).data('target');
        $('.modal').hide();
        $('#js-modal-' + target).show();
        return false;
    });
    $('.js-modal-close').on('click',function(){
        $('.modal').hide();
        return false;
    });
});