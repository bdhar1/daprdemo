from flask import Flask, request, jsonify
from cloudevents.http import from_http
import json
import os
from dapr.clients import DaprClient
import random
import logging

app = Flask(__name__)

app_port = os.getenv('APP_PORT', '7101')

# Register Dapr pub/sub subscriptions
@app.route('/dapr/get', methods=['GET'])
def subscribe():
    id = random.randint(2,200)
    logging.info(id)
    return json.dumps({"status": "success", "orderId":id}) ,200, {
        'ContentType': 'application/json'}

app.run(port=app_port)
