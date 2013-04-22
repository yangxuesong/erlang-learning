-module(callback).
-export([start/0]).

%server side service
start() -> 
	register(proc_name, spawn(module_name, loop, [])).

loop() ->
	receive
		{From, Msg} -> 
			case module_name:callback(From, Msg) of
				{ok, Reply} -> From ! {ok, Reply};
				{error, Why} -> From ! {error, Why}, exit(1)
			end
	end,
	loop().

rpc(Msg) -> 
	proc_name ! Msg.
	receive
		Any -> Any
	end.

%client side api and callback
login(User) -> rpc(User).


callback(From, Msg) -> 
	io:format("~w ~W", [From, Msg]),
	{From, Msg}.
