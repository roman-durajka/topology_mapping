from flask import Flask, jsonify, request
from flask_cors import CORS
import path


app = Flask(__name__)
CORS(app)


@app.route('/path', methods=['POST'])
def get_path():
    req_json = request.json
    path_json = path.main(req_json["source"], req_json["target"], req_json["cost"], req_json["color"])

    return jsonify(path_json)
