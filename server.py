from flask import Flask, make_response, request
from auditer import chat, easter_egg_response
from scraper import save_page_data_to_folder, get_folder_path, get_url_domain
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
        try:
            given_filters = args.get('filters')
            filters = Filters(screen_reader_support=False, sufficient_contrast=False, voice_input=False) 

            if "screen_reader" in given_filters:
                filters.screen_reader_support = True

            if "voice_input" in given_filters:
                filters.voice_input = True

            if "colour_contrast" in given_filters:
                filters.sufficient_contrast = True

        except:
            pass

    print(filters)

    if get_url_domain(url) == "atomicmedia":
        return json.dumps(easter_egg_response(), default= lambda obj: obj.__dict__)


    save_page_data_to_folder(url)

    folder_path = get_folder_path(url)

    if not (os.path.isfile(f"{folder_path}/html.txt") and os.path.isfile(f"{folder_path}/screenshot.png")):
        # Delete empty directory
        make_response('Not a valid website', 400)
    
    with open(f"{folder_path}/html.txt", 'r') as file:
        data = file.read()
        screenshot = f"{folder_path}/screenshot.png"

        return json.dumps(chat(user_input = AccessiblityImprovementRequest(data, screenshot), filters = filters), default= lambda obj: obj.__dict__)