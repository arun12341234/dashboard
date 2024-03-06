import urllib.request
import json

DASHING_URL = 'http://localhost:3030/execution_data'  # Add "widgets/" to the URL
DASHING_AUTH_TOKEN = 'venkatesh'  # Replace with actual auth token

# Construct the request URL
url = DASHING_URL + "?bot_name=" + "AR01"

# Send the GET request
req = urllib.request.Request(url, headers={'Content-Type': 'application/json'})
response = urllib.request.urlopen(req)

# # Read the response data
# data = response.read()

# # Decode the response data
# response_data = json.loads(data)

print(response.read())















# import json
# import urllib.request

# DASHING_URL = 'http://localhost:3030/widgets/'  # Add "widgets/" to the URL
# DASHING_AUTH_TOKEN = 'venkatesh'  # Replace with actual auth token

# req = urllib.request.Request(url, data=json.dumps(widget_json).encode('utf-8'), headers={'Content-Type': 'application/json'})
# response = urllib.request.urlopen(req)

# def update_widget(widget_id, title, value_1):
#     widget_json = {
#         'auth_token': DASHING_AUTH_TOKEN,
#         'title': title,
#         'title1': value_1,
#         'title2': 'Release Date : 05-09-2023',
        
#     }

#     # Construct the full URL including widget ID
#     url = DASHING_URL + widget_id

#     # Send the request
#     req = urllib.request.Request(url, data=json.dumps(widget_json).encode('utf-8'), headers={'Content-Type': 'application/json'})
#     response = urllib.request.urlopen(req)
#     print(response.status)
#     print(response.read().decode('utf-8'))  # Print the response

# # Example usage:
# update_widget('alarm_widget', 'Bot Code : AR01 Version 1', 'Total Records Processed : 8869')
