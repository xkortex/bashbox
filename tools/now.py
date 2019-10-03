#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import datetime

TIME_FMT = "%Y-%m-%d %H:%M:%S.%f"
BLOCK = "█"
# BLOCKS = "▁▂▃▄▅▆▇█"

RULER_LEN = 100
RULE_B = "├"
RULE_M1 = "┴"
RULE_M2 = "┬"
RULE_E = "┤"
RULER = RULE_B + ((RULER_LEN - 2) // 2) * (RULE_M1 + RULE_M2) + RULE_E


def arg_parser():
    import argparse
    parser = argparse.ArgumentParser(description='Clock utility')
    parser.add_argument(
        "-r", "--ruler", action="store_true",
        help="Display a ruler bar chart")

    return parser


def fancy_format_time(t: datetime.datetime, delta_t_us: int) -> str:
    tenths = int(t.microsecond / 1e5)
    block_part = "   |{:_<9}| {:2} ".format(tenths * BLOCK, tenths)
    s_time = t.strftime(TIME_FMT)[10:]
    s_delta_t = " (Δ={:3.0f}µs)".format(delta_t_us)
    return s_time + s_delta_t + block_part


def fancy_format_bar(t: datetime.datetime, columns: int = RULER_LEN) -> str:
    fraction = columns * t.microsecond / 1e6
    cut = int(fraction)
    first = RULER[:cut]
    last = RULER[cut+1:]
    return first + BLOCK + last


def main(ruler=False):
    delta_t = 1
    i = 0
    last = datetime.datetime.now()
    while True:
        now = datetime.datetime.now()
        delta_t = (now - last).microseconds

        if ruler:
            print(fancy_format_bar(now), flush=True, end="\r")
        else:
            s_i = "{:>10} ".format(i)
            fft = fancy_format_time(now, delta_t)
            print(s_i + fft, flush=True, end="\r")
        last = now
        i += 1
        if i > 1e6:
            i = 0


if __name__ == '__main__':
    args = arg_parser().parse_args()
    try:
        main(args.ruler)
    except KeyboardInterrupt:
        print()

