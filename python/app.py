import psutil
from flask import Flask
import os
app = Flask(__name__)

cpu = f'The CPU usage is: {psutil.cpu_percent()} %'

process = psutil.Process(os.getpid())
mem = process.memory_percent()
print(mem)

@app.route('/')
def index():
    return {
        "cpu": cpu
    }

if __name__ == '__main__':
    app.run(host="0.0.0.0")