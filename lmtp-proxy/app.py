from flask import Flask, request, jsonify
import smtplib

app = Flask(__name__)

@app.route('/deliver', methods=['POST'])
def deliver_email():
    data = request.json
    sender = data.get('from', 'noreply@example.com')
    recipient = data.get('to', '')
    subject = data.get('subject', 'No Subject')
    body = data.get('body', '')

    app.logger.info(f"Received request from {request.remote_addr}")
    app.logger.info(f"Headers: {request.headers}")
    app.logger.info(f"Body: {request.get_data().decode('utf-8')}")

    if not recipient:
        return jsonify({"error": "Recipient is required"}), 400

    try:
        with smtplib.LMTP('dovecot', 24) as server:
            server.sendmail(sender, [recipient], f"Subject: {subject}\n\n{body}")
        return jsonify({"message": "Email delivered"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
