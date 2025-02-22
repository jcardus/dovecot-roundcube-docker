from flask import Flask, request, jsonify
import smtplib
import os

app = Flask(__name__)
API_KEY = os.getenv("API_KEY")

@app.route('/deliver', methods=['POST'])
def deliver_email():
    app.logger.info("request")
    if request.headers.get("X-API-Key") != API_KEY:
        return jsonify({"error": "Unauthorized"}), 401    
    try:
        with smtplib.LMTP('dovecot', 24) as server:
            return server.sendmail(
                request.headers.get('from'), 
                request.headers.get('to'),
                request.data), 200
    except Exception as e:
        app.logger.exception(e)
        return str(e), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)