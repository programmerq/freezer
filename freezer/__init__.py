import os, re
import http.client
import urllib.request

class FreezerRequestHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(s):
        print(s.path)
        r=urllib.request.urlopen("http://127.0.0.1:2375/%s" % s.path)
        response=r.read()
        r.close()
        if r.code is 404:
            return
        print(os.getcwd())
        import subprocess
        dir=re.sub('\?.*$', '', (os.path.join(os.getcwd() + s.path)))
        file=os.path.join(dir, 'index.html')
        # print(file, dir)
        subprocess.call("mkdir -p %s" % dir, shell=True)
        fh = open(file, 'wb')
        fh.write(response)
        fh.close()
        s.send_response(r.code)
        s.send_header("Content-type", s.headers['content-type'])
        s.end_headers()

        s.wfile.write(response)
        r.close()
