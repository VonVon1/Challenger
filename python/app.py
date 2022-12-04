import psutil
from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def index():

    hd = psutil.disk_usage('/')
    
    metrics = psutil.disk_io_counters()
    read_time = f'{metrics.read_time} ms'
    write_time = f'{metrics.write_time} ms'

    hd_total =  f'{hd.total // (2**30)} gb' 
    hd_used  =  f'{hd.used // (2**30)} gb'
    hd_free  =  f'{hd.free // (2**30)} gb'

    os.system('sudo apt list --upgradable | tail -n +2 | wc -l > packages-list.txt')

    f = open('packages-list.txt')

    cpu = f'The CPU usage is: {psutil.cpu_percent()} %'

    mem = f'The mem usage is: {psutil.virtual_memory().percent} %'

    content = f.readlines()

    lenlist = len(content)

    return {
        "cpu": cpu, 
        "mem": mem,
        "update_package": lenlist,
        "hd_total": hd_total ,
        "hd_used": hd_used,
        "hd_free": hd_free,
        "read_time": read_time,
        "write_time": write_time
    }


if __name__ == '__main__':
    app.run(host="0.0.0.0")