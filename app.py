import http.server
import freezer
import socketserver
from multiprocessing import Process

def f(name):
    import subprocess
    subprocess.call('socat -v tcp4-listen:2375,bind=127.0.0.1,reuseaddr,fork unix-connect:/var/run/docker.sock', shell=True)

def l(name):
    pass

if __name__ == '__main__':
    # p = Process(target=f, args=('bob',))
    # p.start()


    PORT = 8000

    Handler = freezer.FreezerRequestHandler

    httpd = socketserver.TCPServer(("", PORT), Handler)

    print("serving at port", PORT)
    httpd.serve_forever()
    # p.join()

