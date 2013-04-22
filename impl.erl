-module(impl).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
		terminate/2, code_change/3]).

-export([start_link/0, insert/2, lookup/1, crash/0]).

-define(SERVER, store_server).

	start_link() ->
gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).  %% 回调模块的名称(以及服务器的名字)

	insert(Key, Val) ->
	gen_server:call(?SERVER, {insert, Key, Val}).

	lookup(Key) ->
	gen_server:call(?SERVER, {lookup, Key}).

	crash() ->
	gen_server:call(?SERVER, {crashed}).   %% 发送crashed消息, 这个消息handle_call/3没有处理, 所以crashed掉.

	init([]) ->
{ok, ets:new(?MODULE, [set])}.

handle_call({insert, Key, Val}, _From, State) ->
Reply = ets:insert(State, {Key, Val}), 
{reply, Reply, State};
handle_call({lookup, Key}, _From, State) ->
Reply = ets:lookup(State, Key), 
{reply, Reply, State}.

handle_cast(_Msg, State) ->
{noreply, State}.

handle_info(_Info, State) ->
{noreply, State}.

terminate(_Reason, State) ->    %% 服务器停止, 做一些清理工作.
ets:delete(State),
	ok.

	code_change(_OldVersion, State, _Extra) ->
{ok, State}.
