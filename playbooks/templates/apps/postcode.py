#!/usr/bin/env  python2

from flask import Flask, request
from flask_restplus import Api, Resource, fields
app = Flask(__name__)
api = Api(app, version='0.0.0.0.1', title='Varnish postcode test API', description='Test API voor Varnish by Kasper van Dijk')
postcode = {}

@api.route('/postcode')
class adressen(Resource):
    def get(self, postcode_id):
        return {postcode_id: postcode[postcode_id]}

    def put(self, postcode_id):
        postcode[postcode_id] = request.form['data']
        return {postcode_id: postcode[postcode_id]}

api.add_resource(adressen, '/<string:postcode_id>')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port='5000')
