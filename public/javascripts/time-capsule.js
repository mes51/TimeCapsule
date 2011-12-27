var timeCapsule = {}

timeCapsule.UserInfo = Backbone.Model.extend({
    url: '/user/get_info'
});

timeCapsule.MAX_TWEET_CHAR_LENGTH = 140 - 16;

timeCapsule.View = Backbone.View.extend({
    initialize: function() {
        this.noLogin = $('#no-login');
        this.loggedIn = $('#logged-in');
        this.buryMsg = $('#bury-msg');
        this.loggedIn.hide();
        this.buryMsg.hide();
        this.userInfo = new timeCapsule.UserInfo();
        this.refresh();
    },

    refresh: function() {
        this.userInfo.fetch({success:$.proxy(function() { this.render() }, this)});
    },

    render: function() {
        if (this.userInfo.get('logged_in')) {
            this.noLogin.fadeOut(200);
            this.loggedIn.fadeIn(200);
        } else {
            this.loggedIn.fadeOut(200);
            this.noLogin.fadeIn(200);
        }
    },

    showBuryMsg: function(text) {
        this.buryMsg.text(text);
        this.buryMsg.fadeIn(300).delay(3000).fadeOut(300);
    }
});

$(document).bind('mobileinit', function() {
  $.mobile.ajaxLinksEnabled = false;
  $.mobile.ajaxFormsEnabled = false;
});

$(document).ready(function() {
    var view = new timeCapsule.View();

    $('#post').bind('textchange', function() {
        var c = parseInt($(this).val().length);
        var count = $('#count');
        if (c > timeCapsule.MAX_TWEET_CHAR_LENGTH) {
            $('#submit').disabled = true;
            count.css('color', 'red');
        } else {
            $('#submit').disabled = false;
            count.css('color', 'gray');
        }
        count.text(timeCapsule.MAX_TWEET_CHAR_LENGTH - c);
    });

    $('#logout').bind('click', function() {
        $.ajax({ url: "/user/logout",
                 complete: function() { view.refresh(); } });
    });

    $('#submit').bind('click', function() {
        var text = $('#post').attr("value");
        if (text.length < 1) {
            view.showBuryMsg("テキストが入力されていません");
            return;
        } else if (text.length > timeCapsule.MAX_TWEET_CHAR_LENGTH) {
            view.showBuryMsg("文字数が124文字を超えています");
            return;
        }
        $('#post').attr("value", "");
        $.mobile.showPageLoadingMsg();
        $.ajax({ url: "/post",
                 async: false,
                 type: "POST",
                 data: { post: text,
                           post_time: $('#post-time').attr("value") },
                 success: function() {
                     $.mobile.hidePageLoadingMsg();
                     view.showBuryMsg("タイムカプセルを埋めました");
                 },
                 error: function() {
                     $.mobile.hidePageLoadingMsg();
                     view.showBuryMsg("タイムカプセルを埋め込み時にエラーが発生しました");
                 }
               });
    });
});
