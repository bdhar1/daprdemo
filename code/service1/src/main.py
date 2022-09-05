#!/usr/bin/env python3

from flask import Flask, jsonify, request
from flask_restful import Resource, Api

from logtodb import LogToDb

app = Flask(__name__)
api = Api(app)
api.add_resource(LogToDb, '/')

def main():
  app.run(host="0.0.0.0", port=8081)

if __name__ == '__main__':
  main()
