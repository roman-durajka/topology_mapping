from flask import Flask, jsonify, request
from flask_cors import CORS
import path


app = Flask(__name__)
CORS(app)


@app.route('/', methods=['GET'])
def signal():
    return "It's working!"


@app.route('/path', methods=['POST'])
def get_path():
    req_json = request.json
    path_json = path.main(req_json["source"], req_json["target"], req_json["cost"], req_json["color"])

    return jsonify(path_json)


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000, debug=True)
