import pandas as pd
import geopandas as gpd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error
import joblib

# Load feature-engineered data
gdf = gpd.read_file('feature_engineered_data.geojson')

# Verify columns
print("Columns in the GeoDataFrame:")
print(gdf.columns)

# Define features and target
features = ['hour', 'day_of_week', 'month', 'distance_to_service_center', 'population_density', 'average_income']
target = 'call_volume'

# Check if the features exist in the GeoDataFrame
missing_features = [feature for feature in features if feature not in gdf.columns]
if missing_features:
    print(f"Missing features: {missing_features}")
else:
    print("All features are present.")

X = gdf[features]
y = gdf[target]

# Train-test split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train Random Forest model
model = RandomForestRegressor(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Predict and evaluate
y_pred = model.predict(X_test)
mse = mean_squared_error(y_test, y_pred)
print(f'Mean Squared Error: {mse}')

# Save the model and predictions
joblib.dump(model, 'random_forest_model.pkl')
X_test['predicted_call_volume'] = y_pred
X_test.to_csv('predictions.csv', index=False)
print("Model and predictions saved successfully.")
