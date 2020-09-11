import flask from Flask
from flask_restful import Api, Resource, reqparse

app=Flask(__name__)
api=Api(app)

class State(Resource):

    def get(self):
        