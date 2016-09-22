// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require user/colorbox.js
//= require user/contact.js
//= require user/jqueryui.js
//= require user/owl.carousel.min.js
//= require user/canvas-toBlob.js
//= require user/kinetic-v5.1.0.min.js
//= require user/html2canvas.js
//= require jquery.form
//= require jquery.validate
//= require apprise-1.5.full
//= require xpull
//= require user/modernizr-2.6.2.min
//= require user/hammer.1.1.3.js
//= require user/iscroll-probe.js
//= require user/rangeslider.min.js
//= require user/rangeslider.js

var footer_ids = ['icon_newsfeed', 'icon_search', 'icon_upload', 'icon_closet', 'icon_blogger']

function activate_footer(id) {
    var footer_ids = ['icon_newsfeed', 'icon_search', 'icon_upload', 'icon_closet', 'icon_blogger']
    if (id != 'icon_upload')
        $('#icon_upload').find('#plus').css('transform', 'rotate(0deg)');
    $('#' + id).addClass('active');
    for (var i = 0; i < footer_ids.length; i++) {
        if (footer_ids[i] != id)
            $('#' + footer_ids[i]).removeClass('active');
    }
    window.scrollTo(0, 0);
}

function view_partial(id, action) {
    $('.background_shadow').show();
    activate_footer(id);
    $.ajax({
        url: action,
        processData: false,
        async: false,
        success: function (data) {
            $('.background_shadow').hide();
            $('#popup_upload ').hide();
            $("#main_div").show().html(data);
            $('.background_shadow').hide();
            window.scrollTo(0, 0);
        }
    });
}

function get_partial(id, action, closet) {
    $('.background_shadow').show();
    $.ajax({
        url: action + '?id=' + id,
        processData: false,
        success: function (data) {
            $('.background_shadow').hide();
            $("#_main").hide();
            $("#_sub").show().html(data);
            window.scrollTo(0, 0);
            if (closet)
                $('#closet_bkbtn').show();
        }
    });
}

function render_item(id, action) {
    $('.background_shadow').show();
    $.ajax({
        url: action + '?id=' + id,
        processData: false,
        success: function (data) {
            $('.background_shadow').hide();
            $("#_main").hide();
//            $("#_main").hide();
            $("#item_detail").parent().show().html(data);
//            $("#closet_sub").show().html(data);
            window.scrollTo(0, 0);
        }
    });
}

function get_details(id, action) {
    if (id != '') {
        $('.background_shadow').show();
        $.ajax({
            url: action + '?id=' + id,
            processData: false,
            success: function (data) {
                $('.background_shadow').hide();
//            $("#outfit_detail").hide();
                $("#outfit_detail").parent().show().html(data);
            }
        });
        window.scrollTo(0, 0);
    }
}

function render_newsfeed_view(id, action) {
    $('.background_shadow').show();
    $.ajax({
        url: action + '?id=' + id,
        processData: false,
        success: function (data) {
            $('.background_shadow').hide();
            $("#_main").hide();
            $("#_sub").show().html(data);
            window.scrollTo(0, 0);
        }
    });
}

function comment_back(id, action, div) {
    $('.background_shadow').show();
    $.ajax({
        url: action + '?id=' + id,
        processData: false,
        success: function (data) {
            $('.background_shadow').hide();
            $("#_main").hide();
            $("#" + div).parent().show().html(data);
            window.scrollTo(0, 0);
        }
    });
}

function render_search_view(id, action) {
    $('.background_shadow').show();
    $.ajax({
        url: action + '?id=' + id,
        processData: false,
        success: function (data) {
            $('.background_shadow').hide();
            $("#_main").hide();
            $("#_sub").show().html(data);
            window.scrollTo(0, 0);
        }
    });
}

function render_blogger_view(id, action) {
    $('.background_shadow').show();
    $.ajax({
        url: action + '?id=' + id,
        processData: false,
        success: function (data) {
            $('.background_shadow').hide();
            $("#_main").hide();
            $("#_sub").show().html(data);
            window.scrollTo(0, 0);
        }
    });
}

function render_comments(id, action) {
    $('.background_shadow').show();
    $.ajax({
        url: action + '?id=' + id,
        processData: false,
        success: function (data) {
            $('.background_shadow').hide();
            $("#comment_partial").show().html(data);
            window.scrollTo(0, 0);
        }
    });
}

function render_upload_view(id, action) {
    $('.background_shadow').show();
    $.ajax({
        url: action + '?id=' + id,
        processData: false,
        success: function (data) {
            $('.background_shadow').hide();
            $("#_main").hide();
            $("#_sub").show().html(data);
            window.scrollTo(0, 0);
        }
    });
}

function return_back(id) {
    $('#_sub').hide();
    $('#_main').show();
    show_user_footer();
    if (id == 'closet') {
        $('#user_tab').click();
        $('#blog_tab2').click();
    }
    if (id == 'item_details') {
        refresh_feed();
    }
//    view_partial('icon_closet', '/user/users/user_closet?id=' + id)
    window.scrollTo(0, 0);
}

function return_upload() {
//        view_partial('icon_upload', '/user/user_items/upload_item')
    $("#_main").show();
    $("#_sub").hide();
    $("#item_up").hide();
    show_user_footer();
    window.scrollTo(0, 0);
}

function show_outfit_footer() {
    $('#user_footer').hide();
    $('#outfit_footer').show();
}

function show_user_footer() {
    $('#user_footer').show();
    $('#outfit_footer').hide();
}

function hide_footers() {
    $('#user_footer').hide();
    $('#outfit_footer').hide();
}

function hudMsg(type, message, timeOut) {
    $('.hudmsg').remove();
    if (!timeOut || timeOut == undefined) {
        timeOut = 2000;
    }
    var timeId = new Date().getTime();
    if (type != '' && message != '') {
        $('<div style="z-index: 9999999; font-family: weezerfontregular;" class="hudmsg ' + type.toLowerCase() + '" id="msg_' + timeId + '"><img src="/assets/msg_' + type.toLowerCase() + '.png" alt="" /><p>' + message + '</div>').hide().appendTo('body').fadeIn();
        var timer = setTimeout(
            function () {
                $('.hudmsg#msg_' + timeId + '').fadeOut('slow', function () {
                    $(this).remove();
                });
            }, timeOut
        );
    }
}
//function report_user1(id, type) {
//    $.ajax({
//        url: '/user/users/reporting?id=' + id + '&comment=false&content_type=' + type,
//        success: function (data) {
//            $('#main_div').html(data);
//        }
//    });
//}
