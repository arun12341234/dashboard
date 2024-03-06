class Dashing.Alarm2 extends Dashing.Widget
  @accessor 'send_sms', Dashing.AnimatedValue
  @accessor 'send_mail', Dashing.AnimatedValue
  @accessor 'moreinfo', -> 'Current / in 24h / in 48h'

  @accessor 'send_icon',  ->
	  if @get('title') == 'ASJ Alarm' then 'fa fa-envelope' else 'fa fa-commenting'

  ready: ->
  # This is fired when the widget is done being rendered
  
  onData: (data) ->
  # Handle incoming data
  # You can access the html node of this widget with `@node`
  # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
