%
% source.pl
%  
% Describes a solution for the dust cleaner problem in an 2x2 space using A* algorithm.
%
% @author lucasdavid
%

best_first([], _ , _ )
:-
    write('Solucao nao encontrada'), nl
.

best_first([[_, G, _, _]|T], C, [_, G, _, _])
:-
    write('open: '), printlist([G|T]), nl,
    write('open: '), printlist([G|T]), nl,
    write('closed: '), printlist(C), nl,
    write('OBJETIVO: '), write(G), nl,
    write('Solucao encontrada'), nl
.

%# best_first([[4, [0, 1, 1, 1, 1], 0, 4]], [], [_,[0, 0, 0, 0, 0],_,_])
best_first([[F, S, D, H]|T], C, [_,G,_,_])
:-
    write('open: '), printlist([S|T]), nl,
    write('closed: '), printlist(C), nl,
    findall(X, moves([F, S, D, H], T, C, X), List),
    write('nos gerados: '), printlist(List), nl,
    sort(List, NewList),
    merge(T, NewList, O),
    best_first(O, [[F, S, D, H] | C], [G, _, _, _])
.

moves([F, S, D, H], T, C, [NF, A, NG, NH])
:-
    move(S, A), S \= A,
    not(member([A, _, _, _], T)),
    not(member([A, _, _, _], C)),
    calculaG(S, A, D, NG),
    calculaH(A, NH),
    NF is NG + NH
.

printlist([]).
printlist([[AgentsPos, S0, S1, S2, S3] | T])
:-
    write('Agent\'s position:'), write(AgentsPos), write(' '),
    write('Squares:'), write(S0), write(S1), write(S2), write(S3)
.

%
%
% Returns NewState, a new generated state from a current state @State.
% 
% @param State
% @param out NewState
%
%
%# Right movement
%# Agent's in square [0, 0] or [1, 0]
move([AgentsPos, S0, S1, S2, S3], [AgentsPos +1, S0, S1, S2, S3])
    :- AgentsPos = 0; AgentsPos = 2.

%# Down movement
%# Agent's in square [0, 0] or [0, 1]
move([AgentsPos, S0, S1, S2, S3], [AgentsPos +2, S0, S1, S2, S3])
    :- AgentsPos = 0; AgentsPos = 1.

%# Left movement
%# Agent's in square [0, 1] or [1, 1]
move([AgentsPos, S0, S1, S2, S3], [AgentsPos -1, S0, S1, S2, S3])
    :- AgentsPos = 1; AgentsPos = 3.

%# Up movement
%# Agent's in square [1, 0] or [1, 1]
move([AgentsPos, S0, S1, S2, S3], [AgentsPos -2, S0, S1, S2, S3])
    :- AgentsPos = 2; AgentsPos = 3.

%
%
% Returns G(State), where G is the function cost on a given state @State.
% 
% @param State
% @param out G
%
%
%# When the agent has moved...
calculaG([AgentsPos, S0, S1, S2, S3], [NewAgentsPos, S0, S1, S2, S3], InitialCost, NewCost)
:-
    AgentsPos \= NewAgentsPos,
    NewCost is InitialCost + abs(AgentsPos - NewAgentsPos)
.

%# When the agent has cleaned
calculaG([AgentsPos, S0, S1, S2, S3], [AgentsPos, NewS0, NewS1, NewS2, NewS3], InitialCost, NewCost)
:-
    (S0 \= NewS0 ; S1 \= NewS1 ; S2 \= NewS2 ; S3 \= NewS3),
    NewCost is InitialCost + 3
.

%
%
% Calculates the heuristic function H.
% H(State) = n, where @n is the number of unclean squares in a given state @State.
% 
% @param State
% @param out F
%
%
calculaH([_|Squares], H)
    :- innerCalculaH(Squares, H) .

innerCalculaH([], H)
    :- H = 0 .

innerCalculaH([Square | T], H)
:-
    innerCalculaH(T, InnerH),
    (Square = 1, H is InnerH + 1 ; Square = 0 , H is InnerH)
.
