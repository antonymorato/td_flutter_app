from flask import Flask
from flask_restful import Api, Resource, reqparse
import random
app=Flask(__name__)
api=Api(app)


class State(Resource):

    def generateRandomBoolean(self):
        random_bit = random.getrandbits(1)
        random_boolean = bool(random_bit)
        self.status={'status':random_boolean}

    def get(self):
        self.generateRandomBoolean()
        return self.status,200

api.add_resource(State,"/status")
app.run(debug=True)