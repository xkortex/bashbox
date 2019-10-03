#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import datetime

TIME_FMT = "%Y-%m-%d %H:%M:%S.%f"
BLOCK = "█"
# BLOCKS = "▁▂▃▄▅▆▇█"


def fancy_format_time(t: datetime.datetime, delta_t_us: int) -> str:
    tenths = int(t.microsecond / 1e5)
    block_part = "   |{:_<9}| {:2} ".format(tenths * BLOCK, tenths)
    s_time = t.strftime(TIME_FMT)[10:]
    s_delta_t = " (Δ={:3.0f}µs)".format(delta_t_us)
    return s_time + s_delta_t + block_part


def main():
    delta_t = 1
    i = 0
    last = datetime.datetime.now()
    while True:
        now = datetime.datetime.now()
        delta_t = (now - last).microseconds
        s_i = "{:>10} ".format(i)
        fft = fancy_format_time(now, delta_t)
        print(s_i + fft, flush=True, end="\r")
        last = now
        i += 1
        if i > 1e6:
            i = 0


try:
    main()
except KeyboardInterrupt:
    print()
