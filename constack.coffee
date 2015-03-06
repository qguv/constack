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

set_visible_help = (to_be_visible, fade_callback) ->

  # clear the link while we fade
  $('a#view-full-help').unbind

  if to_be_visible

    # fade out existing help screen and fade ours in
    set_visible_shortcuts false, ->
      $('div#full-help').fadeIn ->
        $('a#view-full-help').addClass 'showing'

        # flip valence of show/hide link
        $('a#view-full-help').click -> set_visible_shortcuts not to_be_visible
  
  else

    # fade out our screen
    $('div#full-help').fadeOut ->
      $('a#view-full-help').removeClass 'showing'
      fade_callback()

      # flip valence of show/hide link
      $('a#view-full-help').click -> set_visible_shortcuts not to_be_visible

  # reverse valence of click handler
  $('a#view-full-help').click -> set_visible_help not to_be_visible

set_visible_shortcuts = (to_be_visible, fade_callback) ->

  # clear the link while we fade
  $('a#view-shortcuts').unbind

  if to_be_visible

    # fade out existing help screen and fade ours in
    set_visible_help false, ->
      $('div#shortcuts').fadeIn ->
        $('a#view-shortcuts').addClass 'showing'

        # flip valence of show/hide link
        $('a#view-shortcuts').click -> set_visible_shortcuts not to_be_visible

  else

    # fade out our screen
    $('div#shortcuts').fadeOut ->
      $('a#view-shortcuts').removeClass 'showing'
      fade_callback()

      # flip valence of show/hide link
      $('a#view-shortcuts').click -> set_visible_shortcuts not to_be_visible

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
  set_visible_help false

  # wire up links to toggle keyboard shortcut reference
  set_visible_shortcuts false

  # wire up all stack elements to respond to clicks 
  rewire_stack()
