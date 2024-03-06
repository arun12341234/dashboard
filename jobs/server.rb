# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  send_event('widget_id', { })
  hrows = [
  { cols: [ {value: 'One'}, {value: 'Two'}, {value: 'Three'}, {value: 'Four'} ] }
  ]

  rows = [
    { cols: [ {value: 'cell11'}, {value: rand(5)}, {value: rand(5)}, {value: rand(5)} ]},
    { cols: [ {value: 'cell21'}, {value: rand(5)}, {value: rand(5)}, {value: rand(5)} ]},
    { cols: [ {value: 'cell31'}, {value: rand(5)}, {value: rand(5)}, {value: rand(5)} ]},
    { cols: [ {value: 'cell41'}, {value: rand(5)}, {value: rand(5)}, {value: rand(5)} ]}
  ]

  send_event('my-table', { hrows: hrows, rows: rows } )
end