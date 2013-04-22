-module(test_sup).
-export([init/1, start/0]).
-behaviour(supervisor).

start() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_) ->
	{ok, {{one_for_one, 3, 10}, 
		[{child1, {my_bank, start, []}, permanent, 10000, worker, [?MODULE]}]
%		{child2, {my_bank, start, []}, permanent, brutal_kill, worker, [?MODULE]}, 
%		{child3, {my_bank, start, []}, permanent, brutal_kill, worker, [?MODULE]}]
		 }}.
