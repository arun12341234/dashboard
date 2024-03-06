class Dashing.ExecutionData extends Dashing.Widget

  ready: ->
      items = @items;
      elements = $(@node).find('a');

      for i in [0..elements.length-1]
          elements[i]["href"] = items[i]["html_url"];

          execution_data
  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.