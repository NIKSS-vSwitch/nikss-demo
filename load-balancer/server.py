#!/usr/bin/env python3

from http.server import HTTPServer, SimpleHTTPRequestHandler
import logging
import sys

logging.basicConfig(stream = sys.stdout, level = logging.INFO)
logger = logging.getLogger("HTTP_server")

get_requests = 0
post_requests = 0

class RequestHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        super().do_GET()
        global get_requests
        get_requests = get_requests + 1

    def do_POST(self):
        super().do_POST()
        global post_requests
        post_requests = post_requests + 1


logger.info("Starting HTTP server on 0.0.0.0 port 8080 (http://0.0.0.0:8080/)...")
logger.info("Press [Ctrl+C] to stop server")
httpd = HTTPServer(("0.0.0.0", 8080), RequestHandler)

try:
    httpd.serve_forever()
except KeyboardInterrupt:
    pass
logger.info("Keyboard interrupt received, exiting.")
httpd.server_close()

logger.info("Total requests processed: {}".format(get_requests + post_requests))
