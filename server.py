from flask import Flask
from auditer import chat
from scraper import save_page_data_to_folder, get_folder_path

DIRECTORY_ROOT= "page_data"

app = Flask(__name__)

@app.route("/health")
def hello():
    return "Hello, World!"

@app.route("/accesiblity-improvments/<path:url>", methods=['GET'])
def get_accessiblity_imorovements(url: str):

    save_page_data_to_folder(url)
    text_response = ''
    with open(f"{get_folder_path(url)}/html.txt", 'r') as file:
        data = file.read()

        for outputChunk in chat(user_input = data):
           text_response += outputChunk

    return text_response