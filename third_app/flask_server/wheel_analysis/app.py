from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
from UGLWheelRawData import mainFun1
from UGLWheelRawData import mainFun2
from ConsolidatedWheelRawData import mainFun4
import os
from datetime import datetime
import supabase

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

        ocr_text=mainFun1(imagepath)
        print(ocr_text)

        return jsonify(ocr_text)
    
@app.route('/upload_ocr', methods=['POST'])
def upload_ocr():
    if request.method == 'POST':
        data = request.get_json()
        mainFun2(data)
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