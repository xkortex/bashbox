from typing import List, Optional, Mapping
from urllib.parse import urlparse, ParseResult
from functools import partial
from dataclasses import dataclass, field
import asyncio
from loguru import logger


class AsDictMxn(object):
    def dict(self):
        return {k: v for k, v in self.__dict__.items()}

    @classmethod
    def meld(cls, *others: Mapping):
        tmp = {}
        for other in others:
            tmp.update(
                {k: v for k, v in other.items() if k in cls.__dataclass_fields__}
            )
        return cls(**tmp)


@dataclass
class ServerArgs(AsDictMxn):
    addr: str = "http://127.0.0.1:4565"
    bufsize: int = 4096


@dataclass
class CliArgs(ServerArgs):
    addrs: List[str] = field(default_factory=list)


class EchoServerProtocol(asyncio.DatagramProtocol):
    def connection_made(self, transport):
        self.transport = transport

    def datagram_received(self, data, addr):
        try:
            message = data.decode()
            logger.info(f"Received UTF8 {len(message)} from {addr!r}:\n{message}")
        except UnicodeDecodeError:
            logger.info(f"Received data {len(data)} from {addr!r}:\n{data!r}")
        self.transport.sendto(data, addr)


async def start_udp_server(client_connected_cb, host=None, port=None, *, loop=None):
    # Get a reference to the event loop as we plan to use
    # low-level APIs.
    loop = asyncio.get_running_loop()
    logger.info("spawning UDP: {} {}".format(host, port))

    # One protocol instance will be created to serve all
    # client requests.
    return await loop.create_datagram_endpoint(
        lambda: client_connected_cb, local_addr=(host, port)
    )


async def start_udp_server2(client_connected_cb=None, host=None, port=None, *, loop=None):

    loop = asyncio.get_running_loop()
    logger.info("spawning UDP: {} {}".format(host, port))
    transport, protocol = await loop.create_datagram_endpoint(
        lambda: EchoServerProtocol(), local_addr=(host, port)
    )
    try:
        await asyncio.sleep(3600)  # Serve for 1 hour.
    finally:
        transport.close()


def get_server_func(addr: str):
    serve_pars: ParseResult = urlparse(addr)
    if serve_pars.scheme == "unix":
        return serve_pars.scheme, partial(
            asyncio.start_unix_server, path=serve_pars.path
        )
    elif serve_pars.scheme == "udp":
        return serve_pars.scheme, partial(
            start_udp_server, host=serve_pars.hostname, port=serve_pars.port
        )
    elif serve_pars.port and serve_pars.hostname:
        return serve_pars.scheme, partial(
            asyncio.start_server, host=serve_pars.hostname, port=serve_pars.port
        )
    else:
        raise ValueError(f"cannot parse URI addr: {addr}")


class Runner(object):
    def __init__(self, args: ServerArgs):
        self.args = args

    async def handle_echo(self, reader, writer):
        data = await reader.read(self.args.bufsize)
        try:
            addr = writer.get_extra_info("peername")
        except Exception as exc:
            addr = "{}: {}".format(exc.__class__.__name__, exc)
        try:
            message = data.decode()
            logger.info(f"Received UTF8 {len(message)} from {addr!r}:\n{message}")
        except UnicodeDecodeError:
            logger.info(f"Received data {len(data)} from {addr!r}:\n{data!r}")

        writer.write(data)
        await writer.drain()

        # print("Close the client socket")
        writer.close()


async def spawn_server(args: ServerArgs):
    logger.debug("spawn: {}".format(args))
    scheme, start_server = get_server_func(args.addr)
    if scheme == "udp":
        server = await start_server(EchoServerProtocol())
        logger.info(f"Serving UDP on {args.addr}")
    else:
        runner = Runner(args)
        server = await start_server(runner.handle_echo)
        myaddr = server.sockets[0].getsockname()
        logger.info(f"Serving on {myaddr}")

    async with server:
        await server.serve_forever()


async def main_server(args: CliArgs):
    logger.debug(args)
    loop = asyncio.get_event_loop()
    cli_dict = args.dict()
    list_of_args = [ServerArgs.meld(cli_dict, {"addr": addr}) for addr in args.addrs]
    futures = [loop.create_task(spawn_server(obj)) for obj in list_of_args]
    logger.debug(list_of_args)
    return futures


def main(args: CliArgs):
    loop = asyncio.get_event_loop()
    future = loop.create_task(main_server(args))
    logger.debug(f"created {future}")
    loop.run_forever()


def arg_parser():
    import argparse

    parser_s = argparse.ArgumentParser(description="""TCP echo server""")

    parser_s.add_argument(
        "-a",
        "--addr",
        default="http://localhost:4565",
        action="store",
        type=str,
        help="Main address to listen/talk on ",
    )
    parser_s.add_argument(
        "-A", "--addrs", default=[], action="append", help="list multiple addresses "
    )

    return parser_s


def cli_main():
    _args = arg_parser().parse_args()
    if _args.addr:
        _args.addrs.append(_args.addr)
    _args = CliArgs(**vars(_args))
    logger.debug(_args)
    main(_args)


if __name__ == "__main__":
    cli_main()
