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


  # Define a hash to keep track of the index for each bot_name
  bot_name_indexes = {}
  index = 0

  # Iterate over the results and populate the data array with additional logic
  results.each do |row|
    bot_name = row['bot_name']
    # Check if the bot_name is already in the dictionary
    if bot_name_indexes.key?(bot_name)
      puts 'Pass'
    else
      # If the bot_name is encountered for the first time, assign it index 0
      bot_name_indexes[bot_name] = index+1  # Assign a new index
      index += 1
    end
    dataid = "rpa_lect#{bot_name_indexes[bot_name]}"
    # puts "#{index} --> #{bot_name} --> #{dataid}"

    # If the bot_name is encountered for the first time, assign it index 0
    # bot_name_indexes[bot_name] ||= bot_name_indexes.size

    # Construct the dataid using the index assigned to the bot_name
    # dataid = "rpa_lect#{bot_name_indexes[bot_name]}"

    data << {
      dataid: dataid,
      bot_name: bot_name,
      total_records_processed: row['total_records_processed'],
      last_updated: row['last_updated']
    }

  end

  # Close the database connection
  client.close

  # Update the dashboard with the fetched data
  data.each do |h|
    send_event h[:dataid], {
      bot_name: h[:bot_name],
      total_records_processed: h[:total_records_processed],
      last_updated: h[:last_updated],
    }
    # puts "Sending event: '#{h},#{h[:dataid]}' with data:"
  end
end

# Schedule the task to run every 30 seconds
scheduler.every '30s' do
  fetch_and_update_dashboard
end

# Initial run of the task
fetch_and_update_dashboard
