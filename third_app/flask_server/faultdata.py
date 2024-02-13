from flask import Flask, request, jsonify
from ontology import get_system, get_equipment, get_location

app = Flask(__name__)

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

if __name__ == '__main__':
    app.run(debug=True)
