from flask import Flask, abort
from auditer import chat, easter_egg_response
from scraper import save_page_data_to_folder, get_folder_path
from request_object import AccessiblityImprovementRequest
import os

DIRECTORY_ROOT= "page_data"

app = Flask(__name__)

@app.route("/health")
def hello():
    return "Hello, World!"

@app.route("/accessibility-improvements/<path:url>", methods=['GET'])
def get_accessiblity_imorovements(url: str):
    text_response = ''

    if url == "https://www.atomicmedia.co.uk/":
        for outputChunk in easter_egg_response():
           text_response += outputChunk

        return text_response


    save_page_data_to_folder(url)

    folder_path = get_folder_path(url)

    if not (os.path.isfile(f"{folder_path}/html.txt") and os.path.isfile(f"{folder_path}/screenshot.png")):
        abort(400, 'Website not found') 
    
    with open(f"{folder_path}/html.txt", 'r') as file:
        data = file.read()
        screenshot = f"{folder_path}/screenshot.png"

        for outputChunk in chat(user_input = AccessiblityImprovementRequest(data, screenshot)):
           text_response += outputChunk

    return text_response