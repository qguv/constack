spush = ->
  oldtip = $('a.topic').first()

  # if the only element before insertion is the empty-stack marker
  if oldtip.attr('id') == 'empty-stack'
    oldtip.hide()
  # if there is another element in the stack
  else
    oldtip.removeClass 'active'

  # generate a new prototype
  newtip = $('a#ptype').clone()
  newtip.removeAttr 'id'
  newtip.removeClass 'hideme'
  newtip.addClass 'active'
  newtip.text $('input').val()

  # put the newly-created item in the document
  newtip.insertBefore oldtip

  # clear out the input field
  $('input').val ''

  # rewire onClick handlers
  rewire_stack()

spop = ->
  # grab old 'doomed' and new 'hotshot' tip-of-stack elements
  doomed = $('a.topic.active').first()
  hotshot = $('a.topic').not('.active').first()
  empty_stack = hotshot.attr('id') == 'empty-stack'

  # blank out the doomed element
  doomed.removeClass 'active'
  doomed.addClass 'disabled'

  if not empty_stack
    hotshot.addClass 'active' # highlight the next element
    doomed.slideUp 300, ->    # get rid of the old element
      @.remove()

  if empty_stack
    doomed.remove()  # instantly remove the old element
    hotshot.fadeIn() # fade in the 'empty stack' placeholder

  # rewire onClick handlers
  rewire_stack()

rewire_stack = ->
  $('a.topic').unbind()
  $('a.topic').not('#ptype').not('#empty-stack').click spop

$(document).ready ->

  # wire up the text field's button
  $('#push').click spush

  # automatically put keyboard focus on the text field
  $('input').focus()
  $('input').select()

  # handle keyboard events from the text field
  # we use keyup rather than keydown here to avoid key repeat
  $('input').keyup (event) ->

    # if return is pressed in a non-empty text field
    spush() if event.which == 13 and $('input').val() != ''

    # if delete is pressed in an empty text field
    spop() if event.which == 0x2e and $('input').val() == ''

  # wire up links to toggle full help/about section
  $('a#show-full-help').click ->
    $('div#full-help').fadeIn()
    $('a#hide-full-help').show()
    $('a#show-full-help').hide()
  $('a#hide-full-help').click ->
    $('div#full-help').fadeOut()
    $('a#show-full-help').show()
    $('a#hide-full-help').hide()

  # wire up links to toggle keyboard shortcut reference
  $('a#show-shortcuts').click ->
    $('div#shortcuts').fadeIn()
    $('a#hide-shortcuts').show()
    $('a#show-shortcuts').hide()
  $('a#hide-shortcuts').click ->
    $('div#shortcuts').fadeOut()
    $('a#show-shortcuts').show()
    $('a#hide-shortcuts').hide()

  # wire up all stack elements to respond to clicks 
  rewire_stack()
