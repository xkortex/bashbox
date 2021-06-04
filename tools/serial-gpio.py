import os
import errno
import socket
from socket import error as socket_error
import sys
import time
import struct
import serial

# Setters are rts, dtr
# Getters are rts, dtr; cts, dsr, ri, cd


class Port(object):
    def __init__(self, parent_serial, name, pin=None):
        self.parent_serial = parent_serial
        self.name = name
        self._pin = pin

    @property
    def pin(self):
        return self._pin

    def get(self):
        return getattr(self.parent_serial, self.name)


class SetterPort(Port):
    def set(self, val):
        return setattr(self.parent_serial, self.name, val)


class SerialGpio(object):
    @classmethod
    def prompt(cls):
        import os
        import glob
        options = glob.Glob('/dev/ttyS*')
        for i, fn in enumerate(options):
            print('{: >2}: {}'.format(i, fn))

        res = input('Select a port')



    def __init__(self, port=None, timeout=None, xonxoff=False):
        ser = serial.Serial(port=port, timeout=timeout, xonxoff=xonxoff)
        self.ser = ser
        self.rts = SetterPort(ser, "rts", 7)
        self.dtr = SetterPort(ser, "dtr", 4)
        self.cts = Port(ser, "cts", 8)
        self.dsr = Port(ser, "dsr", 6)
        self.ri = Port(ser, "ri", 9)
        self.cd = Port(ser, "cd", 1)


