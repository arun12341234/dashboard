class Dashing.Alarm extends Dashing.Widget
  @accessor 'send_sms', Dashing.AnimatedValue
  @accessor 'send_mail', Dashing.AnimatedValue

  @accessor 'send_icon',  ->
#	  if @get('title') == 'ASJ' then 'fa fa-envelope' else 'fa fa-mobile'
	  if @get('title') == 'ASJ' then 'fa fa-envelope' else 'fa fa-commenting'

  ready: ->
  # This is fired when the widget is done being rendered
  
  onData: (data) ->
  # Handle incoming data
  # You can access the html node of this widget with `@node`
  # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.



