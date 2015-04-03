$(document).ready ->
  $('.hidden').fadeIn()
  $('.hidden').removeClass('hidden')



  $(document).on 'change', '.select-hide', ->
    group = $(@).closest('.select-hide-group')
    selected_value = $(@).val()
    $(group).find(".select-hide-content[data-select-hide-for]").each ->
      parent_group =  $(@).closest('.select-hide-group')
      if $(parent_group).is($(group))
        this_div_value =  $(@).data('select-hide-for')
        if this_div_value == selected_value
          $(@).fadeIn()
        else
          $(@).fadeOut()

  $(document).on 'click', '.add-person', ->
    rsvp_id = $(@).data('rsvp-id')
    validation_string = $(@).data('validation-string')
    count = $('.people').data('count')
    $('.people').data('count',count + 1)
    $.get "./ajax_new_person?rsvp_id=#{rsvp_id}&validation_string=#{validation_string}&index=#{count}", (res) ->
      $('.people').append(res)
      $('.person.hidden').fadeIn()
      $('.person.hidden').removeClass('hidden')


