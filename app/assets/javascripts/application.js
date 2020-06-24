// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
/*global $*/

function ready() {
    $('#calcs').click(function(event) {
        $('#calcs-list').slideToggle(100);
        event.stopPropagation();
    });
    
    $('#links').click(function(event) {
        $('#links-list').slideToggle(100);
        event.stopPropagation();
    });

    var containers = document.getElementsByClassName("perfect-scroll");
    for (var i = 0; i < containers.length; i++) {
        new PerfectScrollbar(containers.item(i));
    }
}

$(document).on("click", function(event){
    $("#calcs-list").slideUp("fast");
});

$(document).on("click", function(event){
    $("#links-list").slideUp("fast");
});

$(document).ready(ready);
$(document).on('page:load', ready);