from dapr.clients import DaprClient
import json
import time
import logging
import os
import requests

logging.basicConfig(level=logging.INFO)

for i in range(1, 10):
    order = {'orderId': i}

    with DaprClient() as client:
        # Publish an event/message using Dapr PubSub
        result = client.publish_event(
            pubsub_name='orderpubsub',
            topic_name='daprdemo1',
            data=json.dumps(order),
            data_content_type='application/json',
        )

    logging.info('Published data: ' + json.dumps(order))
    time.sleep(1)
