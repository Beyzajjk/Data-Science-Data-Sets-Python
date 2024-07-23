import pandas as pd
import numpy as np

# Create calls.csv
np.random.seed(42)
calls_data = {
    'call_id': range(1, 101),
    'customer_id': np.random.randint(1, 51, 100),
    'call_time': pd.date_range(start='2023-01-01', periods=100, freq='H').tolist(),
    'call_duration': np.random.randint(1, 30, 100),  # Call duration in minutes
    'call_volume': np.random.randint(1, 10, 100)
}
calls_df = pd.DataFrame(calls_data)
calls_df.to_csv('calls.csv', index=False)
print("calls.csv created.")

# Create customers.csv
customers_data = {
    'customer_id': range(1, 51),
    'name': [f'Customer {i}' for i in range(1, 51)],
    'latitude': np.random.uniform(-90, 90, 50),
    'longitude': np.random.uniform(-180, 180, 50),
    'region_id': np.random.randint(1, 6, 50)
}
customers_df = pd.DataFrame(customers_data)
customers_df.to_csv('customers.csv', index=False)
print("customers.csv created.")

# Create external_factors.csv
external_factors_data = {
    'region_id': range(1, 6),
    'population_density': [1000, 1500, 2000, 2500, 3000],  # People per square kilometer
    'average_income': [30000, 35000, 40000, 45000, 50000]  # Average annual income
}
external_factors_df = pd.DataFrame(external_factors_data)
external_factors_df.to_csv('external_factors.csv', index=False)
print("external_factors.csv created.")
