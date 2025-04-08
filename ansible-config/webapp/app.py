
import logging
from flask import Flask

app = Flask(__name__)

logging.basicConfig(
    filename="/var/log/app.log",
    level=logging.INFO,
    format="%(asctime)s %(levelname)s: %(message)s"
)

@app.route("/")
def hello():
    app.logger.info("Hello endpoint was hit")
    return "Hello from Dockerized Python app!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
