from flask import Flask, jsonify
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from io import BytesIO
import base64

app = Flask(__name__)

# Load data from Excel file
excel_file_path = 'spareParts.xlsx'  # Replace with the actual path
df = pd.read_excel(excel_file_path)

# Keep only 'Date' and 'Description' columns
# Rename the 'Description' column to 'Spare Parts'
df.rename(columns={'Description of part replaced\n(Choose from dropdown)': 'Spare Parts'}, inplace=True)
df = df[['Date', 'Spare Parts']]

# Convert 'Date' column to datetime
df['Date'] = pd.to_datetime(df['Date'])

# Set 'Date' as the index
df.set_index('Date', inplace=True)

@app.route('/get_plot', methods=['GET'])
def get_plot():
    # Assuming 'Spare Parts' is a categorical column and 'Date' is already set as the index
    df['YearMonth'] = df.index.to_period('M')  # Create a new column for Year-Month
    monthly_counts = df.groupby('YearMonth').size()

    # Plot
    plt.figure(figsize=(15, 6))
    sns.lineplot(x=monthly_counts.index.astype(str), y=monthly_counts.values, marker='o')
    plt.title('Time Series Analysis of Spare Parts Count by Month')
    plt.xlabel('Year-Month')
    plt.ylabel('Spare Parts Count')
    plt.xticks(rotation=45, ha='right')

    # Convert plot to base64-encoded image
    buffer = BytesIO()
    plt.savefig(buffer, format='png')
    buffer.seek(0)
    plot_data = base64.b64encode(buffer.read()).decode('utf-8')
    plt.close()

    return jsonify({'plot_data': plot_data})

if __name__ == '__main__':
    app.run(debug=True, port=8000)
