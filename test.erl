-module(test).
-behavior(supervisor).
-export([start_link/0, start_in_shell/0, init/1]).

-define(SERVER, supervisor_server).

%% Erlang Shell的任何crash都会导致supervisor exit.
start_link() ->
	supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_in_shell() ->
{ok, Pid} = supervisor:start_link({local, ?SERVER}, ?MODULE, []),
	unlink(Pid).                    %% 防止shell中的crash导致supervisor server crash


	init([]) ->
{ok, {{one_for_one, 10, 1000},  %% 
	[{tag_store_server,       %% Id
		{impl, start_link, []},  %% StartFunc: {M, F, A}, 决定了如何启动这个worker process.
		permanent,               %% Restart = permanent | transient | temporary
			brutal_kill,             %% Shutdown
			worker,                  %% worker | supervisor
			[impl]}]}}.              %% [Module] 
