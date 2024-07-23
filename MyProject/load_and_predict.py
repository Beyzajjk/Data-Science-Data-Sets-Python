import pandas as pd
import geopandas as gpd
import joblib
import numpy as np

# Load the model
model = joblib.load('random_forest_model.pkl')

# Load feature-engineered data
gdf = gpd.read_file('feature_engineered_data.geojson')

# Define features
features = ['hour', 'day_of_week', 'month', 'distance_to_service_center', 'population_density', 'average_income']

# Check if the features exist in the GeoDataFrame
missing_features = [feature for feature in features if feature not in gdf.columns]
if missing_features:
    print(f"Missing features: {missing_features}")
else:
    print("All features are present.")

# Select the features for prediction
X = gdf[features]

# Predict using the loaded model
predictions = model.predict(X)

# Add predictions to the GeoDataFrame
gdf['predicted_call_volume'] = predictions

# Save the predictions to a new file
gdf.to_file('predictions_with_model.geojson', driver='GeoJSON')

# Display the first few rows of the predictions
print(gdf.head())
