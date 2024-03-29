class Dashing.Hotfloat4ksa2 extends Dashing.Widget
  @accessor 'current', Dashing.AnimatedValue
  @accessor 'moreinfo', -> @get('manager')

  @accessor 'difference', ->
    if @get('last')
      last = parseFloat(@get('last'))
      current = parseFloat(@get('current'))
      if last != 0
        diff = Math.abs(current - last)
        "#{diff}%p"
    else
      ""

  @accessor 'arrow', ->
    if @get('last')
      if parseFloat(@get('current')) > parseFloat(@get('last')) then 'fa fa-arrow-up' else 'fa fa-arrow-down'

  mixin: (data) ->
    if data?
      @updateColor(data)
    super data

  onData: (data) ->
    if data.status
      # clear existing "status-*" classes
      $(@get('node')).attr 'class', (i,c) ->
        c.replace /\bstatus-\S+/g, ''
      # add new class
      $(@get('node')).addClass "status-#{data.status}"

      @updateColor(data)
    

  updateColor: (data) ->
    if data.current?
      node = $(@node)
      currentVal = parseFloat data.current
      cool = parseFloat node.data "cool"
      warm = parseFloat node.data "warm"
      if warm >= cool
        level = switch
          when currentVal <= cool then 1
          when currentVal >= warm then 4
          else 1
      else
        level = switch
          when currentVal >= cool then 3
          when currentVal <= warm then 0
          else  1
  
      backgroundClass = "hotfloat#{level}"
      lastClass = @get "lastClass"
      node.toggleClass "#{lastClass} #{backgroundClass}"
      @set "lastClass", backgroundClass
