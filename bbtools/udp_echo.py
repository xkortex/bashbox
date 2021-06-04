#!/usr/bin/env python
# Python Network Programming Cookbook,   Second Edition -- Chapter - 1
# This program is optimized for Python 2.7.12   and Python 3.5.2.
# It may run on any other version with/without   modifications.

import socket
import sys
import argparse


data_payload = 2048


def echo_server(host, port):
    """ A simple echo server """
    # Create a UDP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    # Bind the socket to the port
    server_address = (host, port)
    print("Starting up echo server             on %s port %s" % server_address)

    sock.bind(server_address)

    while True:
        print("Waiting to receive message                 from client")
        data, address = sock.recvfrom(data_payload)

        print("received %s bytes                 from %s" % (len(data), address))
        print("Data: %s" % data)

        if data:
            sent = sock.sendto(data, address)
            print("sent %s bytes back                    to %s" % (sent, address))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Socket Server Example")
    parser.add_argument("--port", "-P", action="store", type=int, required=True)
    parser.add_argument("--host", "-H", action="store", type=str, default="localhost")
    given_args = parser.parse_args()
    echo_server(given_args.host, given_args.port)
