-module(my_bank).
-behaviour(gen_server).
-export([start/0, stop/0, new_account/1, withdraw/2, deposit/2, query/1, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3, format_status/2]).

start()-> gen_server:start_link(?MODULE, [], []).
stop() -> gen_server:call(?MODULE, stop).

%client apis which execute in client process
new_account(Who) -> gen_server:call(?MODULE, {new, Who}).
withdraw(Who, Number) -> gen_server:call(?MODULE, {withdraw, Who, Number}).
deposit(Who, Number) -> gen_server:call(?MODULE, {deposit, Who, Number}).
query(Who) -> gen_server:call(?MODULE, {query, Who}).

%gen_server callbacks which executes in ?MODULE process
init(Args) -> {ok, ets:new(?MODULE, [])}.

handle_call(Request, From, State) -> Reply = ok, NewState = state, {reply, Reply, NewState}.

handle_cast(Request, State) -> {noreply, State}.
handle_info(Info, State) -> {noreply, State}.
terminate(Reason, State) -> ok. 
code_change(OldVsn, State, Extra) -> {ok, State}.
format_status(Opt, [PDict, State]) -> [PDict, State].
