import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.tsa.arima.model import ARIMA
from flask import Flask, render_template, send_file, request, jsonify
import io
import base64
import seaborn as sns
from io import BytesIO
import supabase 
from rdflib import Graph
from logic import extractFaultSolution
from ontology import get_system, get_equipment, get_location
from werkzeug.utils import secure_filename
from ocr import perform_ocr
import os
from datetime import datetime, timedelta
from supabase import create_client, Client
from ConsolidatedWheelRawData import mainFun4
import pytesseract

#runtime error issue solution
plt.switch_backend('agg')

pytesseract.pytesseract.tesseract_cmd = r'C:\Users\Fatima Abdul Wahid\AppData\Local\Programs\Tesseract-OCR\tesseract.exe'




# Define your Supabase project URL and API key
supabase_url = "https://typmqqidaijuobjosrpi.supabase.co"
supabase_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5cG1xcWlkYWlqdW9iam9zcnBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM0MzkzODAsImV4cCI6MjAwOTAxNTM4MH0.Ihde633Yj9FFaQ7hKLooxDxaFEno4fK8YxSb3gy8S4c"

supabase_client = supabase.Client(supabase_url, supabase_key)


app = Flask(__name__)



def login(username, password):
    # Query Supabase for user with provided username
    query = supabase_client.from_('Users').select('*').eq('username', username)
    response = query.execute()
    print(response)
    
    user = response.data
    mypassword = user[0]['password']
    print("SFjh")
    print(user)
        # Check if the entered password matches the password in the database
    if mypassword== password:
        return True, user
    else:
        return False, "Incorrect password."
    

@app.route('/login', methods=['POST'])
def user_login():
    data = request.get_json()
    if 'username' not in data or 'password' not in data:
        return jsonify({"error": "Missing username or password"}), 400

    username = data['username']
    password = data['password']

    success, user_info = login(username, password)
    print(user_info)
    if success:
        return jsonify({"status": "success", "user_info": user_info})
    else:
        return jsonify({"status": "error", "message": user_info}), 401

#Spare part prediction

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
    df = df.groupby(pd.Grouper(key='Date', freq='M')).sum().reset_index()
    
    return df

def fit_arima(df_monthly):
    model = ARIMA(df_monthly['Quantity'], order=(5, 1, 2))  # ARIMA(p,d,q) order selection might need to be optimized
    model_fit = model.fit()
    return model_fit

def make_predictions(model_fit, start_date, periods):
    # Make predictions
    forecast_index = pd.date_range(start=start_date, periods=periods, freq='M')  # Forecast for given number of months starting from the start_date
    forecast = model_fit.forecast(steps=periods)
    df_predicted = pd.DataFrame({'Date': forecast_index, 'Quantity': forecast})
    return df_predicted



@app.route('/get_plot', methods=['GET'])
def get_plot():

    global new_df
    fileName = 'spareParts.xlsx'
    df = read_data(fileName)
    
    # Display the DataFrame after keeping specific columns
    print(df)
    print("\n")
    
    # Display the DataFrame after aggregating the spare parts by month
    df_actual = aggregate_by_month(df)
    print("Actual Quantity:")
    print(df_actual)
    print("\n")
    
    # Fit ARIMA model
    model_fit = fit_arima(df_actual)
    
    # Make predictions
    start_date = pd.Timestamp('2024-03-01')  # Start date for predictions
    periods = 13  # Number of periods to forecast
    df_predicted = make_predictions(model_fit, start_date, periods)
    print("Forecasted Quantity:")
    print(df_predicted)
    new_df=df_predicted
    print(new_df)
    
    # Combine specific columns from df_actual and df_predicted and add a flag column
    df_combined = pd.concat([
        df_actual[['Date', 'Quantity']].assign(Flag=0), 
        df_predicted[['Date', 'Quantity']].assign(Flag=1)
    ], ignore_index=True)
    
    columns_to_keep = ['Date', 'Quantity', 'Flag']  
    df_combined = df_combined.loc[:, columns_to_keep]

    # Print the combined DataFrame
    print("Combined DataFrame:")
    print(df_combined)

    df_sorted = df_combined.sort_values(by='Date')

    # Create separate DataFrames for each flag
    actual_data = df_sorted[df_sorted['Flag'] == 0]
    predicted_data = df_sorted[df_sorted['Flag'] == 1]

    # Create a figure and axis object
    plt.figure(figsize=(12, 6))

    # Plot actual data with blue color and solid line
    plt.plot(actual_data['Date'], actual_data['Quantity'], label='Actual', color='blue', marker='o')

    # Plot predicted data with orange color and solid line
    plt.plot(predicted_data['Date'], predicted_data['Quantity'], label='Predicted', color='orange', marker='o')

    # Connect the lines between actual and predicted data
    plt.plot([actual_data['Date'].iloc[-1], predicted_data['Date'].iloc[0]],
             [actual_data['Quantity'].iloc[-1], predicted_data['Quantity'].iloc[0]],
             color='orange')

    # Add a legend
    plt.legend()

    # Add title and labels
    plt.title('Actual vs. Predicted Quantity')
    plt.xlabel('Date')
    plt.ylabel('Quantity')

    # Rotate x-axis labels for better readability
    plt.xticks(rotation=45)

    # Show grid
    plt.grid(True)

       # Convert plot to base64-encoded image
    buffer = BytesIO()
    plt.savefig(buffer, format='png')
    buffer.seek(0)
    plot_data = base64.b64encode(buffer.read()).decode('utf-8')
    plt.close()


    # Return the plot data as a JSON response
    return jsonify({'plot_data': plot_data})

@app.route('/get_table', methods=['GET'])
def get_table():
    global new_df  # Access the global variable
    print(new_df)
    # Check if df_predicted is not None
    if new_df  is not None:
        # Convert df_predicted to JSON
        new_df ['Date'] = new_df ['Date'].astype(str)
        new_df['Quantity'] = new_df['Quantity'].astype(float).round(2)

        new_df ['Quantity'] = new_df ['Quantity'].astype(str)

        table_data = new_df.to_json(orient='records')
        print(table_data)
        return jsonify({'table_data': table_data})
    else:
        return jsonify({'error': 'No predicted data available'})



#WHEEL DATA FORM
    

# Create a dictionary to store all data
all_data = {
    'general_info': {},
    'intial_measurement': {},
    'final_measurement': {},
}

@app.route('/')
def home():
    return "Home Page"

@app.route('/general_info', methods=['POST'])

def general_info():
    if request.method == 'POST':
        data = request.get_json()
        a = data['_dateController']
        b = data['_timeController']
        c = data['trainNo']
        d = int(data['wheelSetNo'])


        response_data = {
            'date': a,
            'time': b,
            'trainNo': c,
            'wheelSetNo': d
        }
        
    all_data['general_info'] = data
    return jsonify(response_data)


@app.route('/intial_measurement', methods=['POST'])

def intial_measurement():
    if request.method == 'POST':
        data = request.get_json()
        BLWheelTreadValue = data.get('BLWheelTread', '')
        BRWheelTreadValue = data.get('BRWheelTread', '')
        BLFlangeThicknessValue = data.get('BLFlangeThickness', '')
        BRFlangeThicknessValue = data.get('BRFlangeThickness', '')
        BLFlangeHeightValue = data.get('BLFlangeHeight', '')
        BRFlangeHeightValue = data.get('BRFlangeHeight', '')
        BLFlangeGradientValue = data.get('BLFlangeGradient', '')
        BRFlangeGradientValue = data.get('BRFlangeGradient', '')
        BLRadialDeviationValue = data.get('BLRadialDeviation', '')
        BRRadialDeviationValue = data.get('BRRadialDeviation', '')
      

        # Create a response dictionary
        response_data = {
            'BLWheelTread': BLWheelTreadValue,
            'BRWheelTread': BRWheelTreadValue,
            'BLFlangeThickness': BLFlangeThicknessValue,
            'BRFlangeThickness': BRFlangeThicknessValue,
            'BLFlangeHeight': BLFlangeHeightValue,
            'BRFlangeHeight': BRFlangeHeightValue,
            'BLFlangeGradient': BLFlangeGradientValue,
            'BRFlangeGradient': BRFlangeGradientValue,
            'BLRadialDeviation': BLRadialDeviationValue,
            'BRRadialDeviation': BRRadialDeviationValue,
            
        }
        all_data['intial_measurement'] = data
        return jsonify(response_data)

 
@app.route('/final_measurement', methods=['POST'])
   
def final_measurement():
    if request.method == 'POST':
        data = request.get_json()
        ALWheelTreadValue = data.get('ALWheelTread', '')
        ARWheelTreadValue = data.get('ARWheelTread', '')
        ALFlangeThicknessValue = data.get('ALFlangeThickness', '')
        ARFlangeThicknessValue = data.get('ARFlangeThickness', '')
        ALFlangeHeightValue = data.get('ALFlangeHeight', '')
        ARFlangeHeightValue = data.get('ARFlangeHeight', '')
        ALFlangeGradientValue = data.get('ALFlangeGradient', '')
        ARFlangeGradientValue = data.get('ARFlangeGradient', '')
        ALRadialDeviationValue = data.get('ALRadialDeviation', '')
        ARRadialDeviationValue = data.get('ARRadialDeviation', '')
        
    

        # Create a response dictionary
        response_data = {
            'ALWheelTread': ALWheelTreadValue,
            'ARWheelTread': ARWheelTreadValue,
            'ALFlangeThickness': ALFlangeThicknessValue,
            'ARFlangeThickness': ARFlangeThicknessValue,
            'ALFlangeHeight': ALFlangeHeightValue,
            'ARFlangeHeight': ARFlangeHeightValue,
            'ALFlangeGradient': ALFlangeGradientValue,
            'ARFlangeGradient': ARFlangeGradientValue,
            'ALRadialDeviation': ALRadialDeviationValue,
            'ARRadialDeviation': ARRadialDeviationValue,
            
        }
        all_data['final_measurement'] = data

        # Convert date and time to the required format
       # Extract general info data
        general_info_data = all_data['general_info']
        print("plz",all_data['general_info'])
        print("y",general_info_data)
       # Extract date and time strings
        date_string = general_info_data['_dateController']
        time_string = general_info_data['_timeController']
        
        # Convert date string to a date object
        
        formatted_date = datetime.strptime(date_string, '%Y-%m-%d').date()
        formatted_date = formatted_date.strftime('%Y-%m-%d')
        print(formatted_date)

        # Convert time string to a time object
        
        
        formatted_time = datetime.strptime(time_string, '%H:%M:%S').time()
        formatted_time = formatted_time.strftime('%H:%M:%S')

        

        
        trainNo = general_info_data['trainNo']
        wheelSetNo = general_info_data['wheelSetNo']

         # Extract initial measurement data
        initial_measurement_data = all_data['intial_measurement']
        BLWheelTreadValue = initial_measurement_data['BLWheelTread']
        BRWheelTreadValue = initial_measurement_data['BRWheelTread']
        BLFlangeThicknessValue = initial_measurement_data['BLFlangeThickness']
        BRFlangeThicknessValue = initial_measurement_data['BRFlangeThickness']
        BLFlangeHeightValue = initial_measurement_data['BLFlangeHeight']
        BRFlangeHeightValue = initial_measurement_data['BRFlangeHeight']
        BLFlangeGradientValue = initial_measurement_data['BLFlangeGradient']
        BRFlangeGradientValue = initial_measurement_data['BRFlangeGradient']
        BLRadialDeviationValue = initial_measurement_data['BLRadialDeviation']
        BRRadialDeviationValue = initial_measurement_data['BRRadialDeviation']
        print("geee",BLFlangeGradientValue)

        # Define your Supabase project URL and API key
        supabase_url = "https://typmqqidaijuobjosrpi.supabase.co"
        supabase_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5cG1xcWlkYWlqdW9iam9zcnBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM0MzkzODAsImV4cCI6MjAwOTAxNTM4MH0.Ihde633Yj9FFaQ7hKLooxDxaFEno4fK8YxSb3gy8S4c"

            # Initialize the Supabase client
        supabase_client = supabase.Client(supabase_url, supabase_key)
        table_name = "manualwheelrawdata"
        
        insert_data = {
        'manual_date': formatted_date,
        'manual_time': formatted_time,
        'train_no': trainNo, 
        'wheelset_no':wheelSetNo,
       'blwheeltread': BLWheelTreadValue,
        'brwheeltread': BRWheelTreadValue,  
        'blflangethickness': BLFlangeThicknessValue,  
        'brflangethickness': BRFlangeThicknessValue,  
        'blflangeheight': BLFlangeHeightValue,  
        'brflangeheight': BRFlangeHeightValue,  
        'blflangegradient': BLFlangeGradientValue,  
        'brflangegradient': BRFlangeGradientValue,  
        'bl_axialdeviation': BLRadialDeviationValue,  
        'br_axialdeviation': BRRadialDeviationValue,  
        'alwheeltread': ALWheelTreadValue,  
        'arwheeltread': ARWheelTreadValue,  
        'alflangethickness': ALFlangeThicknessValue,  
        'arflangethickness': ARFlangeThicknessValue, 
        'alflangeheight': ALFlangeHeightValue, 
        'arflangeheight': ARFlangeHeightValue,  
        'alflangegradient': ALFlangeGradientValue,  
        'arflangegradient': ARFlangeGradientValue,  
        'al_axialdeviation': ALRadialDeviationValue,  
        'ar_axialdeviation': ARRadialDeviationValue,  
    }

        supabase_client.table(table_name).insert(insert_data).execute()
                    
      
       
        return jsonify({"message": "Dummy data inserted successfully"})


    
@app.route('/get_combined_data', methods=['GET'])
def get_combined_data():
    return jsonify(all_data)

#Fault Data Form

@app.route('/get_related_system', methods=['POST'])
def get_related_system():
    selected_class = request.json.get('class_instance')

    # Call function to retrieve related equipment
    related_system = get_system(selected_class)

    return jsonify({"related_system": related_system})

@app.route('/get_related_equipment', methods=['POST'])
def get_related_equipment():
    selected_system = request.json.get('system_instance')

    # Call function to retrieve related equipment
    related_equipment = get_equipment(selected_system)

    return jsonify({"related_equipment": related_equipment})

@app.route('/get_related_location', methods=['POST'])
def get_related_location():
    selected_equipment = request.json.get('equipment_instance')

    # Call function to retrieve related equipment
    related_location = get_location(selected_equipment)

    return jsonify({"related_location": related_location})


#Fault Solution 

# Load the OWL file
g = Graph()
g.parse("orange.owl", format="xml")



@app.route('/extract_fault_solution', methods=['POST'])
def api_extract_fault_solution():
    data = request.get_json()

    if 'user_entry_text' not in data:
        return jsonify({'error': 'Missing user_entry_text parameter'}), 400

    user_entry_text = data['user_entry_text']

    # Call your function to extract fault solutions
    fault_solution = extractFaultSolution(user_entry_text)

    # Return the fault solutions as JSON
    return jsonify({'fault_solutions': fault_solution})



# Wheel Analysis

# Define the directory where you want to save the uploaded images
UPLOAD_FOLDER = 'uploadedimages'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Create the upload directory if it doesn't exist
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

@app.route('/upload_image', methods=['POST'])
def upload_image():
    if request.method == 'POST':
        # Check if the 'image' file is included in the request
        if 'image' not in request.files:
            return jsonify({"message": "No file part"})

        imagefile = request.files['image']
        # Check if the file is empty
        if imagefile.filename == '':
            return jsonify({"message": "No selected file"})

        # Securely obtain the filename and save it
        filename = secure_filename(imagefile.filename)
        imagepath=(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        imagefile.save(imagepath)

        ocr_text=perform_ocr(imagepath)
        print(ocr_text)

        return jsonify(ocr_text)
    
@app.route('/upload_ocr', methods=['POST'])
def upload_ocr():
    if request.method == 'POST':
        #try:
            data = request.get_json()
            print(type(data))
            # Access the values using data[]
            a_LHS_Diameter = data['A-LHS-Diameter']
            a_LHS_FlangeThickness = data['A-LHS-FlangeThickness']
            a_LHS_FlangeWidth = data['A-LHS-FlangeWidth']
            a_LHS_Qr = data['A-LHS-Qr']
            a_LHS_RadialDeviation = data['A-LHS-RadialDeviation']
            a_RHS_Diameter = data['A-RHS-Diameter']
            a_RHS_FlangeThickness = data['A-RHS-FlangeThickness']
            a_RHS_FlangeWidth = data['A-RHS-FlangeWidth']
            a_RHS_Qr = data['A-RHS-Qr']
            a_RHS_RadialDeviation = data['A-RHS-RadialDeviation']
            b_LHS_Diameter = data['B-LHS-Diameter']
            b_LHS_FlangeThickness = data['B-LHS-FlangeThickness']
            b_LHS_FlangeWidth = data['B-LHS-FlangeWidth']
            b_LHS_Qr = data['B-LHS-Qr']
            b_LHS_RadialDeviation = data['B-LHS-RadialDeviation']
            b_RHS_Diameter = data['B-RHS-Diameter']
            b_RHS_FlangeThickness = data['B-RHS-FlangeThickness']
            b_RHS_FlangeWidth = data['B-RHS-FlangeWidth']
            b_RHS_Qr = data['B-RHS-Qr']
            b_RHS_RadialDeviation = data['B-RHS-RadialDeviation']
            Date = data['Date']
            Time = data['Time']
            TrainNumber = data['TrainNumber']
            WheelSetNumber = data['WheelSetNumber']
            afterCut = data['afterCut']
            
            # Assuming the Date is in the format "06.06.2023"
            # formatted_date = datetime.strptime(Date, '%d.%m.%Y').date()
            # formatted_date = formatted_date.strftime('%Y-%m-%d')

            # Assuming the Time is in the format "92:50:15"
            # formatted_time = datetime.strptime(Time, '%H:%M:%S').time()
            # formatted_time = formatted_time.strftime('%H:%M:%S')
            
            supabase_url = "https://typmqqidaijuobjosrpi.supabase.co"
            supabase_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5cG1xcWlkYWlqdW9iam9zcnBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM0MzkzODAsImV4cCI6MjAwOTAxNTM4MH0.Ihde633Yj9FFaQ7hKLooxDxaFEno4fK8YxSb3gy8S4c"

                # Initialize the Supabase client
            supabase_client = supabase.Client(supabase_url, supabase_key)
            table_name = "ocrrawdata"
            
            ocr_data = {
                'ocr_date': Date,
                'ocr_time': Time,
                'train_no': TrainNumber,
                'wheelset_no': WheelSetNumber,
                'blwheeltread': b_LHS_Diameter,
                'brwheeltread': b_RHS_Diameter,
                'blflangethickness': b_LHS_FlangeThickness,
                'brflangethickness': b_RHS_FlangeThickness,
                'blflangeheight': b_LHS_FlangeWidth,
                'brflangeheight': b_RHS_FlangeWidth,
                'blflangegradient': b_LHS_Qr ,
                'brflangegradient': a_RHS_Qr ,
                'bl_axialdeviation': b_LHS_RadialDeviation,
                'br_axialdeviation': b_RHS_RadialDeviation,
                'alwheeltread': a_LHS_Diameter,
                'arwheeltread': a_RHS_Diameter,
                'alflangethickness': a_LHS_FlangeThickness,
                'arflangethickness': a_RHS_FlangeThickness,
                'alflangeheight': a_LHS_FlangeWidth,
                'arflangeheight': a_RHS_FlangeWidth,
                'alflangegradient': a_LHS_Qr ,
                'arflangegradient': a_RHS_Qr ,
                'al_axialdeviation': a_LHS_RadialDeviation,
                'ar_axialdeviation': a_RHS_RadialDeviation,
                'aftercut': afterCut
            }

            supabase_client.table(table_name).insert(ocr_data).execute()
  
            return jsonify({"message": "Dummy data inserted successfully"})

@app.route('/upload_manual', methods=['POST'])
def upload_manual():
    if request.method == 'POST':
        #try:
            data = request.get_json()
            print(type(data))
            # Access the values using data[]
            a_LHS_Diameter = data['A-LHS-Diameter']
            a_LHS_FlangeThickness = data['A-LHS-FlangeThickness']
            a_LHS_FlangeWidth = data['A-LHS-FlangeWidth']
            a_LHS_Qr = data['A-LHS-Qr']
            a_LHS_RadialDeviation = data['A-LHS-RadialDeviation']
            a_RHS_Diameter = data['A-RHS-Diameter']
            a_RHS_FlangeThickness = data['A-RHS-FlangeThickness']
            a_RHS_FlangeWidth = data['A-RHS-FlangeWidth']
            a_RHS_Qr = data['A-RHS-Qr']
            a_RHS_RadialDeviation = data['A-RHS-RadialDeviation']
            b_LHS_Diameter = data['B-LHS-Diameter']
            b_LHS_FlangeThickness = data['B-LHS-FlangeThickness']
            b_LHS_FlangeWidth = data['B-LHS-FlangeWidth']
            b_LHS_Qr = data['B-LHS-Qr']
            b_LHS_RadialDeviation = data['B-LHS-RadialDeviation']
            b_RHS_Diameter = data['B-RHS-Diameter']
            b_RHS_FlangeThickness = data['B-RHS-FlangeThickness']
            b_RHS_FlangeWidth = data['B-RHS-FlangeWidth']
            b_RHS_Qr = data['B-RHS-Qr']
            b_RHS_RadialDeviation = data['B-RHS-RadialDeviation']
            Date = data['Date']
            Time = data['Time']
            TrainNumber = data['TrainNumber']
            WheelSetNumber = data['WheelSetNumber']
            
            supabase_url = "https://typmqqidaijuobjosrpi.supabase.co"
            supabase_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5cG1xcWlkYWlqdW9iam9zcnBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM0MzkzODAsImV4cCI6MjAwOTAxNTM4MH0.Ihde633Yj9FFaQ7hKLooxDxaFEno4fK8YxSb3gy8S4c"

                # Initialize the Supabase client
            supabase_client = supabase.Client(supabase_url, supabase_key)
            table_name = "manualwheelrawdata"
            
            manual_data = {
                'manual_date': Date,
                'manual_time': Time,
                'train_no': TrainNumber,
                'wheelset_no': WheelSetNumber,
                'blwheeltread': b_LHS_Diameter,
                'brwheeltread': b_RHS_Diameter,
                'blflangethickness': b_LHS_FlangeThickness,
                'brflangethickness': b_RHS_FlangeThickness,
                'blflangeheight': b_LHS_FlangeWidth,
                'brflangeheight': b_RHS_FlangeWidth,
                'blflangegradient': b_LHS_Qr ,
                'brflangegradient': a_RHS_Qr ,
                'bl_axialdeviation': b_LHS_RadialDeviation,
                'br_axialdeviation': b_RHS_RadialDeviation,
                'alwheeltread': a_LHS_Diameter,
                'arwheeltread': a_RHS_Diameter,
                'alflangethickness': a_LHS_FlangeThickness,
                'arflangethickness': a_RHS_FlangeThickness,
                'alflangeheight': a_LHS_FlangeWidth,
                'arflangeheight': a_RHS_FlangeWidth,
                'alflangegradient': a_LHS_Qr ,
                'arflangegradient': a_RHS_Qr ,
                'al_axialdeviation': a_LHS_RadialDeviation,
                'ar_axialdeviation': a_RHS_RadialDeviation,
            }

            supabase_client.table(table_name).insert(manual_data).execute()
  
            return jsonify({"message": "Dummy data inserted successfully"})
        
@app.route('/wheel_analysis', methods=['POST'])
def wheel_analysis():
    if request.method == 'POST':
        data = request.get_json()
        train_no = data['selected_train_no']
        result = mainFun4(train_no)
        return jsonify(result)
        


# Fault Detection
    
# def check_connection(supabase_client):
#     try:
#         # Retrieve a list of tables to verify the connection
#         tables = supabase_client.table('FaultDetection').select('fault_sol').execute()
#         print("Connection to Supabase successful!")
#         print("Tables in the database:", tables)
#     except Exception as e:
#         print("Error:", e)


@app.route('/fault_detection', methods=['POST'])
def fault_detection():
    if request.method == 'POST':
        data = request.get_json() 
        print(data)

        fault_description = data.get('faultdescController', '')
        fault_solution = data.get('faultsolController', '')

       
      
       
        table_name = "FaultDetection"
        
        insert_faultdata = {
        'fault_desc': fault_description,
        'fault_sol': fault_solution,
        
      
    }
        print(insert_faultdata)
        supabase_client.table(table_name).insert(insert_faultdata).execute()
        

        # Respond back to Flutter application with a success message
        return jsonify({'message': 'Data received successfully'}), 200
    else:
        return jsonify({'error': 'Invalid request method'}), 405


#Trending Fault Data Code

def fetch_all_rows(table_name):
    offset = 0
    all_rows = []
    page_size=1000
    while True:
        response = supabase_client.table(table_name).select("*").range(offset, offset + page_size - 1).execute()
        data = response.data
        if not data:
            break
        all_rows.extend(data)
        if len(data) < page_size:
            break
        offset += page_size
    
    return all_rows

@app.route('/trending_graph')
def generate_graph():
    table_name = "FaultData"
    rows = fetch_all_rows(table_name)
    print("hello")
    print(rows)
    # Date calculations
    current_date = datetime.now().date()
    three_days_ago = current_date - timedelta(days=3)
    ten_days_ago = current_date - timedelta(days=10)

    equipment_faults = {}
    for row in rows:
        equipment = row["Equipment"]
        train_number = row["TrainNumber"]
        car_number = row["CarNumber"]
        fault_date = datetime.strptime(row["OccurrenceDate"], "%Y-%m-%d").date()

        # Form a unique identifier for each equipment entry based on equipment, train number, and car number
        equipment_key = f"{equipment}_{train_number}_{car_number}"

        if equipment_key not in equipment_faults:
            equipment_faults[equipment_key] = {
                "count": 0,
                "recent_fault": False,
                "faults_last_3_days": 0,  # Counter for faults in the last 3 days
                "day_4_to_10": False,
            }

        equipment_faults[equipment_key]["count"] += 1

        # Check if fault occurred in the last 3 days
        if three_days_ago < fault_date <= current_date:
            equipment_faults[equipment_key]["faults_last_3_days"] += 1  # Increment counter
        
        # Check if fault occurred in the days 4 to 10 ago
        if ten_days_ago < fault_date <= three_days_ago:
            equipment_faults[equipment_key]["day_4_to_10"] = True

    # Determine recent_fault based on conditions
    for equipment_key in equipment_faults:
        conditions_met = (
            equipment_faults[equipment_key]["faults_last_3_days"] > 1 or
            (equipment_faults[equipment_key]["faults_last_3_days"] > 0 and equipment_faults[equipment_key]["day_4_to_10"])
        )
        if conditions_met:
            equipment_faults[equipment_key]["recent_fault"] = True

    # Cleanup: Removing the temporary counters and flags
    for equipment_key in equipment_faults:
        del equipment_faults[equipment_key]["faults_last_3_days"]
        del equipment_faults[equipment_key]["day_4_to_10"]

    equipment_faults = {key: val for key, val in equipment_faults.items() if key is not None}

    sorted_equipment = sorted(equipment_faults.items(), key=lambda x: x[1]["count"], reverse=True)[:20]
    equipment_names = [item[0] for item in sorted_equipment]
    faults_counts = [item[1]["count"] for item in sorted_equipment]
    colors = ['red' if item[1]["recent_fault"] else 'skyblue' for item in sorted_equipment]

    plt.figure(figsize=(6, 4))
    bars = plt.bar(equipment_names, faults_counts, color=colors, alpha=0.75, edgecolor='black')
    plt.title("Trending Faults", fontsize=16, fontweight='bold')
    plt.xlabel("Equipment", fontsize=14)
    plt.ylabel("Faults Count", fontsize=14)
    plt.xticks([])
    plt.yticks(fontsize=12)
    plt.grid(color='gray', linestyle='--', linewidth=0.5, axis='y', alpha=0.7)
    
    fixed_vertical_height = 1

    for bar, label in zip(bars, equipment_names):
        yval = bar.get_height()
        plt.text(bar.get_x() + bar.get_width()/2, yval, int(yval), ha='center', va='bottom', fontsize=10, fontweight='bold')
        plt.text(bar.get_x() + bar.get_width()/2, fixed_vertical_height, label, ha='center', va='bottom', fontsize=4, color='black', rotation=90)

    # Save the plot to a BytesIO object
    img = io.BytesIO()
    plt.savefig(img, format='png')
    img.seek(0)

    # Encode the BytesIO object as base64
    img_base64 = base64.b64encode(img.getvalue()).decode()

    plt.close()


    return render_template('index.html', img_base64=img_base64)


if __name__ == '__main__':
    app.run(debug=True, port=8000)
