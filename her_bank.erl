-module(her_bank).
-behaviour(gen_server).
-export([start/0, stop/0, bad/0, new_account/1, withdraw/2, deposit/2, query/1, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3, format_status/2]).

start()-> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
stop() -> gen_server:call(?MODULE, stop).

%client apis which execute in client process
new_account(Who) -> gen_server:call(?MODULE, {new, Who}).
withdraw(Who, Number) -> gen_server:call(?MODULE, {withdraw, Who, Number}).
deposit(Who, Number) -> gen_server:call(?MODULE, {deposit, Who, Number}).
query(Who) -> gen_server:call(?MODULE, {query, Who}).
bad() -> gen_server:call(?MODULE, bad).

%gen_server callbacks which executes in ?MODULE process
init(Args) -> 
	%process_flag(trap_exit, true),
	io:format("her_bank started~n"),
	{ok, ets:new(?MODULE, [])}.

handle_call(notbad, From, Tab) ->
	%exit("crap");
	io:format("notbad");

handle_call({new, Who}, From, Tab) ->
	io:format("~w", [Who]),
	Reply = case ets:lookup(Tab, Who) of
				[] -> ets:insert(Tab, {Who, 0}),
					{welcome, Who};
				[_] -> {Who, you_already_are_a_custom}
			end,
	{reply, Reply, Tab};

handle_call({query, Who}, From, Tab) ->
	Reply = case ets:lookup(Tab, Who) of
				[] -> {Who, you_are_not_a_custom_yet};
				[{Who, Number}] -> {Who, Number}
			end,
	{reply, Reply, Tab};

handle_call({withdraw, Who, Number}, From, Tab) ->
	Reply = case ets:lookup(Tab, Who) of
				[] -> {Who, you_are_not_a_custom_yet};
				[{Who, Amount}] when Amount >= Number ->
					NewAmount = Amount - Number,
					ets:insert(Tab, {Who, NewAmount}),
					{Who, NewAmount};
				[{Who, Amount}] -> {Who, not_enougth_money}
			end,
	{reply, Reply, Tab};

handle_call({deposit, Who, Number}, From, Tab) ->
	Reply = case ets:lookup(Tab, Who) of
				[] -> {Who, you_are_not_a_custom_yet};
				[{Who, Amount}] -> 
					NewAmount = Amount + Number,
					ets:insert(Tab, {Who, NewAmount}),
					{Who, NewAmount}
			end,
	{reply, Reply, Tab};

handle_call(stop, From, Tab) -> 
	{stop, normal, stopped, Tab}.

%other gen_server callbacks
handle_cast(Request, State) -> {noreply, State}.
handle_info(Info, State) -> {noreply, State}.
terminate(Reason, State) -> io:format("~w stopping~n", [?MODULE]), ok. 
code_change(OldVsn, State, Extra) -> {ok, State}.
format_status(Opt, [PDict, State]) -> [PDict, State].
