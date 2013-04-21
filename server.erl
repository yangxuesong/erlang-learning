-module(server).
-export([start/1, handle/1, start2/1]).

%listen on Port
start(Port) ->
	{ok, Listen} = gen_tcp:listen(Port, [binary, {packet, 0}, {active, false}]),
	start_accept(Listen).
	
start_accept(Listen) ->
	{ok, Socket} = gen_tcp:accept(Listen),
	io:format("accepted ~w", [Socket]),
	spawn(?MODULE, handle, [Socket]),
	start_accept(Listen).
	
handle(Socket) ->
	{ok, Packet} = gen_tcp:recv(Socket, 0),
	io:format("send data from client(~w):~s~n", [Socket, binary_to_list(Packet)]),
	ok = gen_tcp:send(Socket, Packet),
	handle(Socket).
	
start2(Port) ->
	spawn(fun () ->
			{ok, Listen} = gen_tcp:listen(Port, [binary, {packet, 0}, {active, true}]),
			{ok, Socket} = gen_tcp:accept(Listen),
			gen_tcp:close(Listen),
			loop(Socket)
		end).

loop(Socket) ->
	io:format("Pid:~w", [self()]),
	receive
		{tcp, Socket, Bin} ->
			io:format("socket receive:~s", [binary_to_list(Bin)]);
		{tcp_closed, Socket} ->
			io:format("socket closed");
		{Pid, Msg} ->
			io:format("Pid receive:~w,~s", [Pid, Msg])
	end,
	loop(socket).