spush = ->
  topel = $('a.topic').first()

  # if the only element before insertion is the empty-stack marker
  if topel.attr('id') == 'empty-stack'
    topel.addClass 'hideme'
  # if there is another element in the stack
  else
    topel.removeClass 'active'

  # generate a new prototype
  ptype = $('a#ptype').clone()
  ptype.removeAttr 'id'
  ptype.removeClass 'hideme'
  ptype.addClass 'active'
  ptype.text $('input').val()

  # put the newly-created item in the document
  ptype.insertBefore topel

  # clear out the input field
  $('input').val ''

  # rewire onClick
  recalc()

spop = ->
  # get rid of the old element
  doomed = $('a.topic.active').first()
  doomed.remove()

  topel = $('a.topic').first()

  # if the only element after deletion is the empty-stack marker
  if topel.attr('id') == 'empty-stack'
    topel.removeClass 'hideme'
  # if there is another element in the stack
  else
    topel.addClass 'active'

  recalc()

recalc = ->
  $('a.topic').unbind()
  $('a.topic.active').first().click spop

$(document).ready ->
  $('#push').click spush

  $('input').focus()
  $('input').select()

  $('input').keyup (event) ->

    # Return pressed
    spush() if event.which == 13

    # Delete pressed #FIXME
    spop() if event.which == 0x2e and $('input').val == ''

  recalc()
