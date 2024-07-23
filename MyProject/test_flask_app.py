import requests
import json

url = 'http://127.0.0.1:5000/predict'
headers = {'Content-Type': 'application/json'}

data = {
    "hour": 10,
    "day_of_week": 3,
    "month": 7,
    "distance_to_service_center": 15.5,
    "population_density": 2000,
    "average_income": 45000
}

response = requests.post(url, headers=headers, data=json.dumps(data))

print("Status Code:", response.status_code)
print("Response JSON:", response.json())
