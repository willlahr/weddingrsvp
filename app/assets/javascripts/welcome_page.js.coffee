# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->


  will_offset = 0
  roz_offset = 0
  roz_increment = 4
  will_increment = 3




  window.setInterval ->
    image_height = $('.roz').height()
    max_offset =   $('.roz').parent().height() - image_height
    roz_offset = roz_offset + roz_increment
    will_offset = will_offset + will_increment
    if roz_offset > max_offset
      roz_increment = roz_increment * -1
      roz_offset = max_offset

    if will_offset > max_offset
      will_increment = will_increment * -1
      will_offset = max_offset

    if roz_offset < 0
      roz_offset = 0
      roz_increment = roz_increment * -1

    if will_offset < 0
      willl_offset = 0
      will_increment = will_increment * -1




    $(".will").css('padding-top', roz_offset)
    $(".roz").css('padding-top', will_offset)
  , 100

