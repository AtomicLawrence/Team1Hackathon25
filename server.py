from flask import Flask, make_response, request
from auditer import chat, easter_egg_response
from scraper import save_page_data_to_folder, get_folder_path
from request_object import AccessiblityImprovementRequest
from filters import Filters
import json
import os

DIRECTORY_ROOT= "page_data"

app = Flask(__name__)

@app.route("/health")
def hello():
    return "Hello, World!"

@app.route("/accessibility-improvements/<path:url>", methods=['GET'])
def get_accessiblity_imorovements(url: str):
    args = request.args
    filters = Filters()
    if args:
        # Turn off filters as necessary here
        pass

    if url == "https://www.atomicmedia.co.uk/":
        return json.dumps(easter_egg_response(), default= lambda obj: obj.__dict__)


    save_page_data_to_folder(url)

    folder_path = get_folder_path(url)

    if not (os.path.isfile(f"{folder_path}/html.txt") and os.path.isfile(f"{folder_path}/screenshot.png")):
        # Delete empty directory
        make_response('Not a valid website', 400)
    
    with open(f"{folder_path}/html.txt", 'r') as file:
        data = file.read()
        screenshot = f"{folder_path}/screenshot.png"

        return json.dumps(chat(user_input = AccessiblityImprovementRequest(data, screenshot)), default= lambda obj: obj.__dict__)