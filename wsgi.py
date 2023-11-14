from flask import Flask, jsonify, request
from flask_cors import CORS
import path
import main
from modules import asset_mapper


app = Flask(__name__)
CORS(app)


@app.route('/', methods=['GET'])
def signal():
    """
    Endpoint to check app status.
    :return: str
    """
    return "It's working!"


@app.route('/add-path', methods=['POST'])
def add_path():
    """
    Endpoint to create and return path based on POST data.
    :return: data in json format and status code
    """
    req_json = request.json
    result = {}
    try:
        path_json = path.add_path(req_json)
        result.update(path_json)
        result["code"] = 200
    except Exception as error:
        result["error"] = str(error)
        result["code"] = 500

    return jsonify(result)


@app.route('/remove-path', methods=['POST'])
def remove_path():
    """
    Endpoint to remove path from database.
    :return: data in json format and status code
    """
    req_json = request.json
    result = {}
    try:
        path.remove_path(req_json)
        result["code"] = 200
    except Exception as error:
        result["error"] = str(error)
        result["code"] = 500

    return jsonify(result)


@app.route('/load-paths', methods=['GET'])
def load_saved_paths():
    """
    Endpoint to load and return all saved paths.
    :return: data in json format and status code
    """
    result = {}
    try:
        paths = path.load_paths()
        result.update({"data": paths})
        result["code"] = 200
    except Exception as error:
        result["error"] = str(error)
        result["code"] = 500

    return jsonify(result)


@app.route('/topology', methods=['GET'])
def create_topology():
    """
    Endpoint to create and return topology data to be drawn in js app.
    :return: data in json format and status code
    """
    result = {}
    try:
        js_data = main.main()
        result["data"] = js_data
        result["code"] = 200
    except Exception as error:
        result["error"] = str(error)
        result["code"] = 500

    return jsonify(result)


@app.route('/assets', methods=['GET'])
def get_mapped_assets():
    """
    Endpoint to create and return assets along with risks/vulnerabilities/threats.
    :return: data in json format and status code
    """
    result = {}
    try:
        mapped_assets = asset_mapper.get_mapped_assets()
        result.update(mapped_assets)
        #result["code"] = 200
    except Exception as error:
        result["error"] = str(error)
        #result["code"] = 500

    return jsonify(result)


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
