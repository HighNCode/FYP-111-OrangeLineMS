import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.tsa.arima.model import ARIMA
from flask import Flask, render_template, send_file
from flask import Flask, jsonify
import pandas as pd
import io
import base64
import matplotlib.pyplot as plt
import seaborn as sns
from io import BytesIO
from flask import request
import base64
from flask import Flask, jsonify, request,send_file
import supabase 
from datetime import datetime
from flask import Flask, request, jsonify
from rdflib import Graph
from logic import extractFaultSolution
from ontology import get_system, get_equipment, get_location
from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
from ocr import perform_ocr
import os
from datetime import datetime, timedelta
from supabase import create_client, Client
from datetime import datetime
from ConsolidatedWheelRawData import mainFun4
import pytesseract;
pytesseract.pytesseract.tesseract_cmd = r'C:\Users\Fatima Abdul Wahid\AppData\Local\Programs\Tesseract-OCR\tesseract.exe'


# Define your Supabase project URL and API key
supabase_url = "https://typmqqidaijuobjosrpi.supabase.co"
supabase_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5cG1xcWlkYWlqdW9iam9zcnBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM0MzkzODAsImV4cCI6MjAwOTAxNTM4MH0.Ihde633Yj9FFaQ7hKLooxDxaFEno4fK8YxSb3gy8S4c"

supabase_client = supabase.Client(supabase_url, supabase_key)


app = Flask(__name__)






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




if __name__ == '__main__':
    app.run(debug=True, port=8000)
