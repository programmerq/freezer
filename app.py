import http.server
import freezer
import socketserver

PORT = 8000

Handler = freezer.FreezerRequestHandler

httpd = socketserver.TCPServer(("", PORT), Handler)

print("serving at port", PORT)
httpd.serve_forever()

