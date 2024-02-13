from flask import Flask, jsonify, request,send_file
# import psycopg2
import supabase 
from datetime import datetime
# # Define your PostgreSQL database connection parameters
# db_params = {
#     'dbname': 'OrangeLine',
#     'user': 'postgres',
#     'password': '2870',
#     'host': 'localhost',  
#     'port': '5432',  
# }
# # Add this line to create a connection to the database
# conn = psycopg2.connect(**db_params)
# cursor = conn.cursor()




app = Flask(__name__)


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

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)

