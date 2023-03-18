from flask import Flask, jsonify, request
from flask_cors import CORS
import path
import main


app = Flask(__name__)
CORS(app)


@app.route('/', methods=['GET'])
def signal():
    """
    Endpoint to check app status.
    :return: str
    """
    return "It's working!"


@app.route('/path', methods=['POST'])
def get_path():
    """
    Endpoint to create and return path based on POST data.
    :return: data in json format and status code
    """
    req_json = request.json
    path_json = path.main(req_json)

    return jsonify(path_json), 200


@app.route('/topology', methods=['GET'])
def create_topology():
    """
    Endpoint to create and return topology data to be drawn in js app.
    :return: data in json format and status code
    """
    js_data = main.main()

    return jsonify({"status": "success", "data": js_data}), 200


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
