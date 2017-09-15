import http.server
import freezer
import socketserver
from multiprocessing import Process
import subprocess

def f():
    subprocess.call('while true; do socat tcp4-listen:2375,bind=127.0.0.1,reuseaddr,fork unix-connect:/var/run/docker.sock; done', shell=True)

def l():
    PORT = 8000

    Handler = freezer.FreezerRequestHandler

    httpd = socketserver.TCPServer(("", PORT), Handler)

    print("serving at port", PORT)
    httpd.serve_forever()

def i():
    # subprocess.call('bash -x interrogator.sh')
    f=subprocess.Popen("bash -x interrogators.sh", shell=True, env={"DOCKER_HOST": 'tcp://127.0.0.1:8000'}, stdout=subprocess.PIPE, stdin=subprocess.PIPE)
    f.wait()

if __name__ == '__main__':
    socat = Process(target=f)
    socat.start()
    collector = Process(target=l, args=())
    collector.start()
    interrogator = Process(target=i)
    interrogator.start()
    interrogator.join()
    collector.terminate()
    socat.terminate()
    collector.join()
    socat.join()

