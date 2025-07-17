from flask import Flask

app = Flask(__name__)

@app.route("/health")
def hello():
    return "Hello, World!"

@app.route("/accesiblity-improvments/<path:url>", methods=['GET'])
def get_accessiblity_imorovements(url):
    return f"Page to get accessiblity improvements from: {url}"