from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
from ocr import perform_ocr
import os
from datetime import datetime
import supabase
from ConsolidatedWheelRawData import mainFun4
import pytesseract;
pytesseract.pytesseract.tesseract_cmd = r'C:\Users\Fatima Abdul Wahid\AppData\Local\Programs\Tesseract-OCR\tesseract.exe'


app = Flask(__name__)

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
        
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)