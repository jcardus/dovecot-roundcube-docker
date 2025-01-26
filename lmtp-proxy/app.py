from flask import Flask, request, jsonify
import smtplib
import os

app = Flask(__name__)
API_KEY = os.getenv("API_KEY")

@app.route('/deliver', methods=['POST'])
def deliver_email():
    if request.headers.get("X-API-Key") != API_KEY:
        return jsonify({"error": request.data}), 401

    if request.headers.get("X-API-Key") != API_KEY:
        return jsonify({"error": "Unauthorized"}), 401
    
    if not recipient:
        return jsonify({"error": "Recipient is required"}), 400

    try:
        with smtplib.LMTP('dovecot', 24) as server:
            server.sendmail(sender, [recipient], f"Subject: {subject}\n\n{body}")
        return jsonify({"message": "Email delivered"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
