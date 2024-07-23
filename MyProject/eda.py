import pandas as pd
import geopandas as gpd
import matplotlib.pyplot as plt

# Load feature-engineered data
gdf = gpd.read_file('feature_engineered_data.geojson')

# Verify columns
print("Columns in the GeoDataFrame:")
print(gdf.columns)

# Plot call volumes by region
gdf.plot(column='call_volume', cmap='OrRd', legend=True)
plt.title('Call Volume by Region')
plt.show()

# Time series analysis
data = pd.read_csv('calls.csv')  # Re-load the original calls data
data['call_time'] = pd.to_datetime(data['call_time'])
data.set_index('call_time').resample('D').size().plot()
plt.title('Call Volume Over Time')
plt.show()
