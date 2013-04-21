-module(math2).
-export([area/1, around/1]).

area({rectangle, A, B}) ->
	A * B;
area({triangle, A, B, C}) ->
	S = (A + B + C) / 2,
	math:sqrt(S * (S - A) * (S - B) * (S - C)).
	
around({rectangle, A, B}) ->
	2 * (A + B);
around({triangle, A, B, C}) ->
	A + B + C.