import pandas as pd
import geopandas as gpd
from datetime import datetime
from shapely.geometry import Point
import os

# Load datasets
calls_df = pd.read_csv('calls.csv')
customers_df = pd.read_csv('customers.csv')
external_factors_df = pd.read_csv('external_factors.csv')

# Merge datasets
data = calls_df.merge(customers_df, on='customer_id').merge(external_factors_df, on='region_id')

# Convert to GeoDataFrame
geometry = [Point(xy) for xy in zip(data.longitude, data.latitude)]
gdf = gpd.GeoDataFrame(data, geometry=geometry)

# Feature Engineering
# Create time-based features
gdf['call_time'] = pd.to_datetime(gdf['call_time'])
gdf['hour'] = gdf['call_time'].dt.hour
gdf['day_of_week'] = gdf['call_time'].dt.dayofweek
gdf['month'] = gdf['call_time'].dt.month

# Calculate distance to the nearest service center
def haversine(lon1, lat1, lon2, lat2):
    from math import radians, cos, sin, asin, sqrt
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])
    dlon = lon2 - lon1 
    dlat = lat2 - lat1 
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a))
    r = 6371
    return c * r

service_center_coords = (-74.0060, 40.7128)  # Example coordinates
gdf['distance_to_service_center'] = gdf.apply(
    lambda row: haversine(row['longitude'], row['latitude'], service_center_coords[0], service_center_coords[1]), axis=1)

# Check if the columns were created
print("Feature-engineered columns:")
print(gdf[['hour', 'day_of_week', 'month', 'distance_to_service_center']].head())

# Save the feature-engineered data
output_file = 'feature_engineered_data.geojson'
gdf.to_file(output_file, driver='GeoJSON')

if os.path.exists(output_file):
    print(f"Feature engineered data saved successfully as {output_file}.")
else:
    print(f"Failed to create {output_file}.")
