from flask import Flask, jsonify, request
from flask_cors import CORS
import path
import topology
from modules import asset_mapper, subpages, data_loader
from modules.exceptions import DuplicitDBEntry

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
        result["data"] = path_json
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
        topology_obj = topology.Topology()
        js_data = topology_obj.decide_and_return_topology()
        result["data"] = js_data
        result["code"] = 200
    except Exception as error:
        result["error"] = str(error)
        result["code"] = 500

    return jsonify(result)


@app.route('/topology-update', methods=['POST'])
def topology_update():
    """
    Endpoint to update topology data, specifically DB `topology`.

    :return: data in json format and status code
    """
    req_json = request.json
    result = {}
    try:
        topology_obj = topology.Topology()
        topology_obj.topology_update(req_json)
        result["code"] = 200
    except Exception as error:
        result["error"] = str(error)
        result["code"] = 500

    return jsonify(result)


@app.route('/application-groups', methods=['GET'])
def get_application_groups():
    """
    Endpoint to return current application_groups.

    :return: data in json format and status code
    """
    result = {}
    try:
        application_groups = asset_mapper.get_application_groups(False)
        result["data"] = application_groups
        result["code"] = 200
    except Exception as error:
        result["error"] = str(error)
        result["code"] = 500

    return jsonify(result)


@app.route('/update-application-groups', methods=['POST'])
def update_application_groups():
    """
    Endpoint to save updated (edited) application groups to database.

    :return: data in json format and status code
    """
    req_json = request.json
    result = {}
    try:
        asset_mapper.update_application_groups(req_json)
        result["code"] = 200
    except Exception as error:
        result["error"] = str(error)
        result["code"] = 500

    return jsonify(result)


@app.route('/add-device', methods=['POST'])
def add_device():
    """
    Endpoint to add new device added on frontend to db.

    :return: data in json format and status code
    """
    req_json = request.json
    result = {}
    try:
        topology_obj = topology.Topology()
        data = topology_obj.add_device(req_json)
        result["data"] = data
        result["code"] = 200
    except Exception as error:
        result["error"] = str(error)
        result["code"] = 500

    return jsonify(result)


# ENDPOINTS TO UPDATE TOPOLOGY DATA USING PREDEFINED SCHEME

@app.route('/scheme-update', methods=['POST'])
def scheme_update():
    """
    Endpoint to update topology data in db using scheme uploaded by user.

    :return: data in json format and status code
    """
    req_json = request.json
    result = {}
    try:
        scheme_importer = subpages.SchemeImportLibreNMS(req_json)
        scheme_importer.update_db_from_scheme()
        result["code"] = 200
    except DuplicitDBEntry as error:
        result["error"] = str(error)
        result["code"] = 409
    except KeyError as error:
        result["error"] = f"Key error somewhere in the code: {error}. Can't tell you more without debugging..."
        result["code"] = 500
    except Exception as error:
        result["error"] = str(error)
        result["code"] = 500

    return jsonify(result)


@app.route('/scheme-replace', methods=['POST'])
def scheme_replace():
    """
    Endpoint to replace already uploaded data that were already in DB.

    :return: data in json format and status code
    """
    req_json = request.json
    result = {}
    try:
        scheme_importer = subpages.SchemeImportLibreNMS(req_json)
        scheme_importer.update_db_from_scheme(True)
        result["code"] = 200
    except KeyError as error:
        result["error"] = f"Key error somewhere in the code: {error}. Can't tell you more without debugging..."
        result["code"] = 500
    except Exception as error:
        result["error"] = str(error)
        result["code"] = 500

    return jsonify(result)


# ENDPOINTS FOR DEVICES SUBPAGE

@app.route('/devices-get', methods=['GET'])
def devices_get():
    """
    Endpoint to return all data used when loading subpage 'devices'.

    :return: data in json format and status code
    """
    result = {}
    try:
        devices = subpages.Devices()
        result["data"] = devices.get_devices()
        result["code"] = 200
    except Exception as error:
        result["error"] = str(error)
        result["code"] = 500

    return jsonify(result)


@app.route('/devices-update', methods=['POST'])
def devices_update():
    """
    Endpoint to update data using the 'devices' subpage.

    :return: data in json format and status code
    """
    req_json = request.json
    result = {}
    try:
        devices = subpages.Devices()
        result["data"] = devices.update_devices(req_json)
        result["code"] = 200
    except Exception as error:
        result["error"] = str(error)
        result["code"] = 500

    return jsonify(result)


@app.route('/devices-delete', methods=['POST'])
def devices_delete():
    """
    Endpoint to delete data using the 'devices' subpage.

    :return: data in json format and status code
    """
    req_json = request.json
    result = {}
    try:
        devices = subpages.Devices()
        devices.delete_row(req_json)
        result["code"] = 200
    except Exception as error:
        result["error"] = str(error)
        result["code"] = 500

    return jsonify(result)


# ENDPOINTS FOR RISK MANAGEMENT SUBPAGE

@app.route('/risk-management', methods=["GET"])
def risk_management_load():
    """
    Returns risk management data for all application groups. If fired for the
    first time, loads all risk management data from MOSP and other sources
    into local DB first. This might take from few seconds up to tens of
    seconds.
    """
    result = {}
    try:
        data_load = data_loader.DataLoader()
        data_load.decide_and_load_data()
        application_groups = asset_mapper.get_application_groups(True)
        result["data"] = application_groups
        result["code"] = 200
    except Exception as error:
        result["error"] = str(error)
        result["code"] = 500

    return jsonify(result)

@app.route('/risk-management-update', methods=["POST"])
def risk_management_update():
    """
    Updates risk management data.
    """
    req_json = request.json
    result = {}
    try:
        asset_mapper.update_asset(req_json)
        result["code"] = 200
    except Exception as error:
        result["error"] = str(error)
        result["code"] = 500

    return jsonify(result)


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
