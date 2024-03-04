import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.tsa.arima.model import ARIMA
from flask import Flask, jsonify
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from io import BytesIO
import base64

app = Flask(__name__)


def read_data(fileName):
    
    # Read the Excel file into a DataFrame
    df = pd.read_excel(fileName)

    # Get column names
    column_names = df.columns
    print(column_names)
    print("\n")

    # Define columns to keep
    columns_to_keep = ['Train No.', 'System ', 'Date', 'Quantity']  

    # Keep specific columns
    df = df.loc[:, columns_to_keep]
    
    return df

def aggregate_by_month(df):
    
    # Convert 'Date' column to datetime if it's not already
    df['Date'] = pd.to_datetime(df['Date'])
    
    # Group by month and sum the quantities
    df = df.groupby(pd.Grouper(key='Date', freq='M')).sum()
    
    return df

def fit_arima(df_monthly):

    model = ARIMA(df_monthly['Quantity'], order=(5,1,2))  # ARIMA(p,d,q) order selection might need to be optimized
    model_fit = model.fit()
    return model_fit
    
    
@app.route('/get_plot', methods=['GET'])
def plot_graph():

    global df_predicted 
    fileName = 'spareParts.xlsx'
    df = read_data(fileName)
    
    # Display the DataFrame after keeping specific columns
    print(df)
    print("\n")
    

    # Display the DataFrame after aggregating the spare parts by month
    df_actual = aggregate_by_month(df)
    print("Actual Quantity: ")
    print(df_actual)
    print("\n")
    
    # Fit ARIMA model
    model_fit = fit_arima(df_actual)

    # Manually set the start date for the forecast index to March 2024
    start_date = pd.Timestamp('2024-03-01')
    
    # Make predictions
    forecast_index = pd.date_range(start=start_date, periods=13, freq='M')  # Forecast for 13 months including March 2024
    forecast = model_fit.forecast(steps=len(forecast_index)) 
    monthly_forecast = pd.Series(forecast, index=forecast_index)
    df_predicted = monthly_forecast.reset_index().rename(columns={"index": "Date", "predicted_mean": "Forecasted_Quantity"})

    # Print predicted values
    print("Forecasted Quantity:")
    print(df_predicted)

    # Visualize Results
    
    plt.figure(figsize=(10, 5))  # Adjust figure size if needed
    plt.plot(df_actual.index, df_actual['Quantity'], label='Actual', marker='o')
    plt.plot(df_predicted['Date'], df_predicted['Forecasted_Quantity'], label='Predicted', linestyle='--', marker='o')
    plt.title('ARIMA Forecast for Total Quantity')
    plt.xlabel('Month')
    plt.ylabel('Quantity')
    plt.legend()
    plt.grid(True)  
    plt.xticks(rotation=45)  
    plt.tight_layout() 
    # plt.show()

     # Convert plot to base64-encoded image
    buffer = BytesIO()
    plt.savefig(buffer, format='png')
    buffer.seek(0)
    plot_data = base64.b64encode(buffer.read()).decode('utf-8')
    plt.close()

    return jsonify({'plot_data': plot_data})

@app.route('/get_table', methods=['GET'])
def get_table():
    global df_predicted  # Access the global variable
    
    # Check if df_predicted is not None
    if df_predicted is not None:
        # Convert df_predicted to JSON
        df_predicted['Date'] = df_predicted['Date'].astype(str)
        table_data = df_predicted.to_json(orient='records')
        return jsonify({'table_data': table_data})
    else:
        return jsonify({'error': 'No predicted data available'})


if __name__ == '__main__':
    app.run(debug=True, port=8000)
