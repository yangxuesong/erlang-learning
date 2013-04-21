-module(client).
-export([connect/1]).

connect(Port) ->
	{ok, Socket} = gen_tcp:connect("localhost", Port, [binary, {packet, 0}, {active, false}]),
	io:format("connected ~w", [Socket]),
	handle(Socket).

handle(Socket) ->
	ok = gen_tcp:send(Socket, "hello world"),
	{ok, Packet} = gen_tcp:recv(Socket, 0),
	io:format("send data from server(~w):~s~n", [Socket, binary_to_list(Packet)]),
	timer:sleep(10000),
	handle(Socket).