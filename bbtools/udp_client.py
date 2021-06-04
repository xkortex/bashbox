#!/usr/bin/env python
# Python Network Programming Cookbook, Second Edition -- Chapter - 1
# This program is optimized for Python 2.7.12 and Python 3.5.2.
# It may run on any other version with/without modifications.

import socket
import sys
import argparse


data_payload = 2048


def echo_client(host, port):
    """ A simple echo client """
    # Create a UDP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    server_address = (host, port)
    print("Connecting to %s port %s" % server_address)
    message = "This is the message.  It will be                repeated."

    try:

        # Send data
        message = "Test message. This will be                    echoed"
        print("Sending %s" % message)
        sent = sock.sendto(message.encode("utf-8"), server_address)

        # Receive response
        data, server = sock.recvfrom(data_payload)
        print("received %s" % data)

    finally:
        print("Closing connection to the server")
        sock.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Socket Server Example")
    parser.add_argument("--port", "-P", action="store", type=int, required=True)
    parser.add_argument("--host", "-H", action="store", type=str, default="localhost")

    _args = parser.parse_args()

    echo_client(_args.host, _args.port)
