from flask import Flask, request, jsonify
from cloudevents.http import from_http
import json
import os
from dapr.clients import DaprClient
import uuid
import logging

app = Flask(__name__)

app_port = os.getenv('APP_PORT', '6004')

# Register Dapr pub/sub subscriptions
@app.route('/dapr/subscribe', methods=['GET'])
def subscribe():
    subscriptions = [{
        'pubsubname': 'orderpubsub',
        'topic': 'daprdemo1',
        'route': 'orders'
    }]
    print('Dapr pub/sub is subscribed to: ' + json.dumps(subscriptions))
    return jsonify(subscriptions)


# Dapr subscription in /dapr/subscribe sets up this route
@app.route('/orders', methods=['POST'])
def orders_subscriber():
    event = from_http(request.headers, request.get_data()).data
    j = json.loads(event)
    print('Subscriber received : %s' % event, flush=True)
    DAPR_STORE_NAME = os.getenv("DAPR_STORE_NAME", "pgstatestore")
    with DaprClient() as client:
      id = str(uuid.uuid4())
      # Save state into the state store
      client.save_state(DAPR_STORE_NAME, id, event)
      print('Saving Order: %s', DAPR_STORE_NAME)
    return json.dumps({'success': True}), 200, {
        'ContentType': 'application/json'}


app.run(port=app_port)
