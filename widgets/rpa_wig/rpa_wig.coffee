class Dashing.RpaWig extends Dashing.Widget


  onData: (data) ->
    if data.status
      # clear existing "status-*" classes
      $(@get('node')).attr 'class', (i,c) ->
        c.replace /\bstatus-\S+/g, ''
      # add new class
      $(@get('node')).addClass "status-#{data.status}"

      @updateColor(data)
    
  redirect: (data) ->
    if data? and data.innerText.trim() isnt ""
        link_data = data.innerText.split("\n")[0]
        console.log(link_data)
        location.href = 'execution_data?bot_name=' + encodeURIComponent(link_data)
        # location.href = 'execution_data'
    else
        console.log("not exist")

