$(document).ready ->
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

