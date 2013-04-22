-module(proc_exit).
-export([fork_link/0, func/0, func/1, grand_child_loop/0]).

fork_link() ->
	Pid = spawn(?MODULE, func, []),
	io:format("~w~n", [Pid]),
	register(parent, Pid).
	%{Pid, spawn(?MODULE, func, [Pid])}.

func() ->
	Pid = spawn(?MODULE, func, [self()]),
	register(child, Pid),
	io:format("~w~n", [Pid]),
	parent_loop().

parent_loop() ->
	receive
		{Pid, [Item1|_]} -> 
			io:format("parent1: ~w ~w~n", [Pid, Item1]),
			parent_loop();
		{Pid, Msg} -> 
			io:format("parent2: ~w ~w~n", [Pid, Msg]),
			list_to_atom(Msg) %必须异常退出/exit link机制才会有效
	end.
	
func(Pid) ->
	process_flag(trap_exit, true),
	register(grand_child, spawn_link(?MODULE, grand_child_loop, [])),
	io:format("~w~w~n", [self(), Pid]),
	io:format("~w~n", [link(Pid)]),
	child_loop().

child_loop() ->
	receive
		{'EXIT', Pid, Why} -> io:format("child1: ~w ~w~n", [Pid, Why]);%只有System Process才会收到此消息
		{Pid, Msg} -> io:format("child2: ~w ~w~n", [Pid, Msg])
	end,
	child_loop().

grand_child_loop() ->
	receive
		{Pid, [Item1|_]} -> 
			io:format("parent1: ~w ~w~n", [Pid, Item1]),
			parent_loop();
		{Pid, Msg} -> 
			io:format("parent2: ~w ~w~n", [Pid, Msg]),
			list_to_atom(Msg) %必须异常退出/exit link机制才会有效
	end.