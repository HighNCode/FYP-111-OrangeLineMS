from flask import Flask, request, jsonify

# User database (for demonstration purposes)
user_database = [
    {"username": "zuha603", "full_name": "Zuha Umar", "password": "zuha123", "occupation": "Engineer"},
    {"username": "fatima711", "full_name": "Fatima Abdul Wahid", "password": "fatima123", "occupation": "Engineer"},
    {"username": "waleed2440", "full_name": "Waleed Bin Osama", "password": "waleed123", "occupation": "Engineer"},
    {"username": "hadiya579", "full_name": "Hadiya Farooq", "password": "hadiya1233", "occupation": "Manager"},
]

app = Flask(__name__)

def login(username, password):
    # Check if username exists in the database
    for user in user_database:
        if user["username"] == username:
            # Check if the entered password matches the password in the database
            if user["password"] == password:
                return True, user
            else:
                return False, "Incorrect password."
    return False, "Username not found."

@app.route('/login', methods=['POST'])
def user_login():
    data = request.get_json()
    if 'username' not in data or 'password' not in data:
        return jsonify({"error": "Missing username or password"}), 400

    username = data['username']
    password = data['password']

    success, user_info = login(username, password)
    if success:
        return jsonify({"status": "success", "user_info": user_info})
    else:
        return jsonify({"status": "error", "message": user_info}), 401

if __name__ == '__main__':
   app.run(debug=True, port=8000)
