#!/usr/bin/env python3

import json
import os

from flask import Response
from flask_restful import Resource
from dapr.clients import DaprClient

class LogToDb(Resource):

  def post(self):
    appName = os.getenv("APP_NAME", "ServiceApp2")
    print("Hello from Service 2")

    self.SaveToStateStore(appName)
    
    message = json.dumps({"status": "success", })
    return Response(message, status = 201, mimetype = "application/json")
  
  def SaveToStateStore(self, appName: str):
    print("Saving for " + appName)