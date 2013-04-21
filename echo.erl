-module(echo).
-export([start/0, loop/0]).

start() ->
	io:format("start...\n"),
	spawn(echo, loop, []).
	
loop() ->
	receive
		{From, Msg} -> 
			From ! Msg,
			loop
	end.