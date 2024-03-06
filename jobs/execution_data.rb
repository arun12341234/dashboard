# encoding: utf-8

require 'mysql2'
require 'rufus-scheduler'

# Create a scheduler
scheduler = Rufus::Scheduler.new

# Define the task to fetch data and update the dashboard
def fetch_and_update_dashboard
  client = Mysql2::Client.new(
    host: 'localhost',
    username: 'root',
    password: 'Password@123',
    database: 'RPA_Dashboard'
  )

  # Fetch data from MySQL
  query = "SELECT * FROM Bot_Data"  # Replace 'Bot_Data' with the name of your table
  results = client.query(query)

  # Define an empty array to store the fetched data
  data = []
  bot_data = [
    "a",
    "b",
    "c"
  ]
  @bot_data = bot_data

  # Close the database connection
  client.close


  puts "Sending event: "
end
@bot_data = ["item1", "item2", "item3"]
# Initial run of the task
fetch_and_update_dashboard

print "byeeeeeeeeeeeeeee"

# encoding: utf-8

require 'mysql2'
require 'rufus-scheduler'

# Create a scheduler
scheduler = Rufus::Scheduler.new

# Define a hash to store data for each bot name
$bot_data_hash = {}
$bot_name_indexes = {}
# Define the task to fetch data and update the dashboard
def fetch_and_update_dashboard2
  client = Mysql2::Client.new(
    host: 'localhost',
    username: 'root',
    password: 'Password@123',
    database: 'RPA_Dashboard'
  )

  # Fetch data from MySQL
  query = "SELECT * FROM Bot_Data"  # Replace 'Bot_Data' with the name of your table
  results = client.query(query)

  # Define an empty array to store the fetched data
  data = []


  # Define a hash to keep track of the index for each bot_name
  # bot_name_indexes = {}
  index = 0


  # Iterate over the results and populate the data array with additional logic
  results.each do |row|
    bot_name = row['bot_name']
    
    # Check if the bot_name is already in the dictionary
    if $bot_name_indexes.key?(bot_name)
      puts 'Pass'
    else
      # If the bot_name is encountered for the first time, assign it index 0
      $bot_name_indexes[bot_name] = index+1  # Assign a new index
      index += 1
    end
    puts bot_name
    puts row
    puts $bot_name_indexes
    # Initialize an array for the bot name if it doesn't exist
    $bot_data_hash[bot_name] ||= []
    # Add the row data to the array corresponding to the bot name
    $bot_data_hash[bot_name] << row
    # puts $bot_data_hash
  end
  # Set up table headers
  table_headers = [
    { value: "Bot Name" }, 
    { value: "Date released into production" }, 
    { value: "Total records processed" }, 
    { value: "Total failed records" }, 
    { value: "Average processing of 1 record" },
    { value: "Daily/Weekly/Monthly" },
    { value: "Bot not running" },
    { value: "Last Updated" }
  ]
  # puts $bot_data_hash.keys
  # Loop through all keys in bot_data_hash
  
  $bot_data_hash.keys.each do |key|
    puts "Key: #{key}"
    pages_stats = {}
    # puts "Data: #{$bot_data_hash[key]}"
    
    $bot_data_hash[key].each do |row|
      puts "Key data: #{row}"
      bot_name = row['bot_name']
      date_released = row['date_released']
      total_records_processed = row['total_records_processed']
      total_failed_records = row['total_failed_records']
      avg_processing_time = row['avg_processing_time']
      processing_frequency = row['processing_frequency']
      bot_not_running = row['bot_not_running']
      last_updated = row['last_updated']
      # puts pages_stats
      pages_stats[row['id']] = {bot_name: bot_name, date_released: date_released, total_records_processed: total_records_processed, total_failed_records: total_failed_records, avg_processing_time: avg_processing_time, processing_frequency: processing_frequency, bot_not_running: bot_not_running, last_updated: last_updated}

    end
    puts pages_stats
    send_event("pages_#{key}", { table_headers: table_headers, pages: pages_stats.values })


end

end
fetch_and_update_dashboard2


# mock_data = [
#   ["Page Title 1", "/blog/page1", 100],
#   ["Page Title 2", "/blog/page2", 80],
#   ["Page Title 3", "/blog/page3", 70],
#   ["Page Title 4", "/blog/page4", 60],
#   ["Page Title 5", "/blog/page5", 50],
#   ["Page Title 6", "/blog/page6", 40],
#   ["Page Title 7", "/blog/page7", 30],
#   ["Page Title 8", "/blog/page8", 20],
#   ["Page Title 9", "/blog/page9", 10],
#   ["Page Title 10", "/blog/page10", 5],
#   ["Page Title 11", "/blog/page11", 150],
#   ["Page Title 12", "/blog/page12", 140],
#   ["Page Title 13", "/blog/page13", 130],
#   ["Page Title 14", "/blog/page14", 120],
#   ["Page Title 15", "/blog/page15", 110],
#   ["Page Title 16", "/blog/page16", 100],
#   ["Page Title 17", "/blog/page17", 90],
#   ["Page Title 18", "/blog/page18", 80],
#   ["Page Title 19", "/blog/page19", 70],
#   ["Page Title 20", "/blog/page20", 60],
#   ["Page Title 21", "/blog/page21", 55],
#   ["Page Title 22", "/blog/page22", 54],
#   ["Page Title 23", "/blog/page23", 53],
#   ["Page Title 24", "/blog/page24", 52],
#   ["Page Title 25", "/blog/page25", 51],
#   ["Page Title 26", "/blog/page26", 50],
#   ["Page Title 27", "/blog/page27", 49],
#   ["Page Title 28", "/blog/page28", 48],
#   ["Page Title 29", "/blog/page29", 47],
#   ["Page Title 30", "/blog/page30", 46],
#   ["Page Title 31", "/blog/page31", 45],
#   ["Page Title 32", "/blog/page32", 44],
#   ["Page Title 33", "/blog/page33", 43],
#   ["Page Title 34", "/blog/page34", 42],
#   ["Page Title 35", "/blog/page35", 41],
#   ["Page Title 36", "/blog/page36", 40],
#   ["Page Title 37", "/blog/page37", 39],
#   ["Page Title 38", "/blog/page38", 38],
#   ["Page Title 39", "/blog/page39", 37],
#   ["Page Title 40", "/blog/page40", 36],
#   ["Page Title 41", "/blog/page41", 35],
#   ["Page Title 42", "/blog/page42", 34],
#   ["Page Title 43", "/blog/page43", 33],
#   ["Page Title 44", "/blog/page44", 32],
#   ["Page Title 45", "/blog/page45", 31],
#   ["Page Title 46", "/blog/page46", 30],
#   ["Page Title 47", "/blog/page47", 29],
#   ["Page Title 48", "/blog/page48", 28],
#   ["Page Title 49", "/blog/page49", 27],
#   ["Page Title 50", "/blog/page50", 26]
# ]

# # Set up table headers
# table_headers = [{ value: "Title" }, { value: "Views" }]

# # Process mock data
# pages_stats = {}
# mock_data.each do |row|
#   title = row[0]
#   html_url = row[1]
#   views = row[2]

#   pages_stats[title] = { title: title, html_url: html_url, views: views }
# end
# puts pages_stats
# # Send processed data to dashboard widget
# send_event("pages_AR01", { table_headers: table_headers, pages: pages_stats.values })
