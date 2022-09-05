#!/usr/bin/env python3

import json
import os
import requests
import logging
import uuid
import datetime

from flask import Response
from flask_restful import Resource
from werkzeug.exceptions import NotFound, BadRequest
from dapr.clients import DaprClient

class LogToDb(Resource):

  def post(self):
    appName = os.getenv("APP_NAME", "ServiceApp1")
    print("Hello from Service 1")

    self.CallSisterAPI()
    self.SaveToStateStore(appName)
    
    message = json.dumps({"status": "success", })
    return Response(message, status = 201, mimetype = "application/json")

  def CallSisterAPI(self):
    sisAppName = os.getenv("SIS_APP_NAME", "ServiceApp2")
    base_url = os.getenv('BASE_URL', 'http://localhost') + ':' + os.getenv('DAPR_HTTP_PORT', '3500')
    print("Calling Sister App")

    headers = {'dapr-app-id': sisAppName, 'content-type': 'application/json'}
    resp = requests.post(
        url='%s/' % (base_url),
        data=None,
        headers=headers
    )

    if resp.status_code == 404:
      raise NotFound()
    elif resp.status_code != 201:
      raise BadRequest()
    
    print(resp.text)

  
  def SaveToStateStore(self, appName: str):
    print("Saving for " + appName)

    DAPR_STORE_NAME = os.getenv("DAPR_STORE_NAME", "pgstatestore")
    with DaprClient() as client:
      id = str(uuid.uuid4())
      ct = datetime.datetime.now()
      data = {'appId': appName, 'timestamp': ct}

      # Save state into the state store
      client.save_state(DAPR_STORE_NAME, id, str(data))
      logging.info('Saving Order: %s', DAPR_STORE_NAME)
