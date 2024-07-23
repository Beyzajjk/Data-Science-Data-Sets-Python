from flask import Flask, request, jsonify
import joblib
import pandas as pd
import numpy as np
from shapely.geometry import Point
import geopandas as gpd

app = Flask(__name__)

# Load the model
model = joblib.load('random_forest_model.pkl')

# Define features
features = ['hour', 'day_of_week', 'month', 'distance_to_service_center', 'population_density', 'average_income']

@app.route('/')
def home():
    return "Call Center GeoRF Model API"

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    # Extract the input data from the JSON
    input_data = {
        'hour': data['hour'],
        'day_of_week': data['day_of_week'],
        'month': data['month'],
        'distance_to_service_center': data['distance_to_service_center'],
        'population_density': data['population_density'],
        'average_income': data['average_income']
    }
    
    # Convert the input data to a DataFrame
    df = pd.DataFrame([input_data])

    # Predict using the loaded model
    prediction = model.predict(df)
    
    # Return the prediction
    return jsonify({'predicted_call_volume': prediction[0]})

if __name__ == '__main__':
    app.run(debug=True)
