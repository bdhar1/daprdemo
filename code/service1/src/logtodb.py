#!/usr/bin/env python3

import json
import os

from flask import Response
from flask_restful import Resource

class LogToDb(Resource):

  def post(self):
    appName = os.getenv("APP_NAME", "App1")
    print("Hello")

    self.CallSisterAPI()
    self.SaveToStateStore(appName)
    
    message = json.dumps({"status": "success", })
    return Response(message, status = 201, mimetype = "application/json")

  def CallSisterAPI(self):
    sisAppName = os.getenv("SIS_APP_NAME", "App1")
    print("Calling Sister App")
  
  def SaveToStateStore(self, appName: str):
    print("Saving for " + appName)