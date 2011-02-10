var home_images = ['home2.jpg','home3.jpg','home4.jpg','home5.jpg'];

(function($) {
    var cache = [];
  // Arguments are image paths relative to the current page.
    $.preLoadImages = function() {
	var args_len = arguments.length;
	for (var i = args_len; i--;) {
	    var cacheImage = document.createElement('img');
	    cacheImage.src = arguments[i];
	    cache.push(cacheImage);
	}
    }

    $.fadeOutIn = function() {
	$(this).fadeOut('slow');
    }

    $.changeHomePhoto = function(me) {
	$(me).attr('src', '/images/' + home_images[Math.floor(Math.random()*4)]);
    }
})(jQuery)

$(document).ready(function() {
    var pathname = window.location.pathname;
    if(pathname.substr(-4) == 'home') {
	jQuery.preLoadImages("/images/home2.jpg",
			     "/images/home3.jpg",
			     "/images/home4.jpg",
			     "/images/home5.jpg");
	$(window).bind('load', function() {
//	    setTimeout($('#home5').fadeOut('slow'), 10000);
//	    setTimeout($('#home4').fadeOut('slow'), 10000);
//	    setTimeout($('#home3').fadeOut('slow'), 10000);
//	    setTimeout($('#home2').fadeOut('slow'), 10000);
	});
    }
    /*
    $("#home_img img").mouseenter(function() {
	$.changeHomePhoto(this);
    });
    $("#home_img img").mouseout(function() {
	$.changeHomePhoto(this);
    });
    */
    var timer = setInterval(function () {
	var home_img = $("#home_img img");
	$.changeHomePhoto(home_img);
    }, 5000);
});
