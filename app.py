import http.server
import freezer
import socketserver
from multiprocessing import Process
import subprocess

def f():
    """running socat is a hacky workaround until I can figure out how to get python to connect over a unix domain socket"""
    subprocess.call('while true; do socat tcp4-listen:42375,bind=127.0.0.1,reuseaddr,fork unix-connect:/var/run/docker.sock; done', shell=True)

def l():
    PORT = 8000

    Handler = freezer.FreezerRequestHandler

    httpd = socketserver.TCPServer(("", PORT), Handler)

    print("serving at port", PORT)
    httpd.serve_forever()

def i():
    """using an external bash script is a hopefully temporary measure until I can write a proper python docker client loop to accomplish the same thing."""
    # subprocess.call('bash -x interrogator.sh')
    f=subprocess.Popen("bash -x interrogators.sh", shell=True, env={"DOCKER_HOST": 'tcp://127.0.0.1:8000'}, stdout=subprocess.PIPE, stdin=subprocess.PIPE)
    f.wait()

if __name__ == '__main__':
    # start up the socat hack first
    socat = Process(target=f)
    socat.start()

    # Run the actual core piece of logic-- take a request and store the response
    collector = Process(target=l, args=())
    collector.start()

    # generate requests to be run through the collector
    interrogator = Process(target=i)
    interrogator.start()
    interrogator.join()

    # once the interrogator is done, we can turn off the collector and the socat
    collector.terminate()
    socat.terminate()
    collector.join()
    socat.join()

