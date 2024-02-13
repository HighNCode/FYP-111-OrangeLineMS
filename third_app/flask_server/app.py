from flask import Flask, request, jsonify
from rdflib import Graph
from logic import extractFaultSolution

app = Flask(__name__)

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

if __name__ == '__main__':
    app.run(debug=True)
