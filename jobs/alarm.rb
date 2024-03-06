# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  # send_event(
  #   'alarm_widget', 
  #   {  
  #     value_1: 2,
  #     value_2: 3,
  #     value_3: 1,
  #     value_4: 5,
  #     value_5: 20,
  #   }
  #   )
  
  
end