%
% source.pl
%  
% Describes a solution for the dust cleaner problem in an 2x2 space using A* algorithm.
%
% @author lucasdavid
%
% Input example:
% best_first([[4, [0, 1, 1, 1, 1], 0, 4]], [], [_,[0, 0, 0, 0, 0],_,_]).

best_first([], _ , _ )
:-
    write('Solucao nao encontrada'), nl
.

best_first([[F, G, D, H]|T], C, [_, G, _, _])
:-
    write('Solucao encontrada'), nl,
    
    write('Open'), nl,
    printlist([[F, G, D, H]|T]), nl,
    
    write('Closed'), nl,
    printlist(C), nl,

    write('Objetivo: '), write(G), nl
.

best_first([[F, S, D, H]|T], C, [_,G,_,_])
:-
    write('Open'), nl,
    printlist([[F, S, D, H]|T]), nl,
    
    write('Closed'), nl,
    printlist(C), nl,
    
    findall(X, moves([F, S, D, H], T, C, X), List),
    
    write('Nos gerados'), nl,
    printlist(List), nl,
    
    sort(List, NewList),
    merge(T, NewList, O),
    
    best_first(O, [[F, S, D, H] | C], [_, G, _, _])
.

moves([F, S, D, H], T, C, [NF, A, ND, NH])
:-
    move(S, A), S \= A,
    not(member([_, A, _, _], T)),
    not(member([_, A, _, _], C)),
    calculaG(S, A, D, ND),
    calculaH(A, NH),
    NF is ND + NH
.

printlist([])
:-
    nl.

printlist([[F, [AgentsPos, S0, S1, S2, S3], D, H] | T])
:-
    write(AgentsPos), write(' '),
    write(S0), write(S1), write(S2), write(S3),
    write(' F='), write(F),
    write(' D='), write(D),
    write(' H='), write(H),
    write(', '), printlist(T)
.

% Returns NewState, a new generated state from a current state @State.
% 
% @param State
% @param out NewState
%
%
% Right movement
% Agent's in square [0, 0] or [1, 0]
move([AgentsPos, S0, S1, S2, S3], [NewAgentsPos, S0, S1, S2, S3])
:-
    (AgentsPos = 0; AgentsPos = 2),
    NewAgentsPos is AgentsPos + 1
.

% Down movement
% Agent's in square [0, 0] or [0, 1]
move([AgentsPos, S0, S1, S2, S3], [NewAgentsPos, S0, S1, S2, S3])
:-
    (AgentsPos = 0; AgentsPos = 1),
    NewAgentsPos is AgentsPos + 2
.

% Left movement
% Agent's in square [0, 1] or [1, 1]
move([AgentsPos, S0, S1, S2, S3], [NewAgentsPos, S0, S1, S2, S3])
:-
    (AgentsPos = 1; AgentsPos = 3),
    NewAgentsPos is AgentsPos - 1
.

% Up movement
% Agent's in square [1, 0] or [1, 1]
move([AgentsPos, S0, S1, S2, S3], [NewAgentsPos, S0, S1, S2, S3])
:-
    (AgentsPos = 2; AgentsPos = 3),
    NewAgentsPos is AgentsPos - 2
.

% Cleaning
move([AgentsPos, S0, S1, S2, S3], [AgentsPos, 0, S1, S2, S3])
    :- AgentsPos = 0, S0 = 1.

move([AgentsPos, S0, S1, S2, S3], [AgentsPos, S0, 0, S2, S3])
    :- AgentsPos = 1, S1 = 1.

move([AgentsPos, S0, S1, S2, S3], [AgentsPos, S0, S1, 0, S3])
    :- AgentsPos = 2, S2 = 1.

move([AgentsPos, S0, S1, S2, S3], [AgentsPos, S0, S1, S2, 0])
    :- AgentsPos = 3, S3 = 1.

% Returns G(State), where G is the function cost on a given state @State.
% 
% @param State
% @param out G
%
%
% When the agent has moved...
calculaG([AgentsPos, S0, S1, S2, S3], [NewAgentsPos, S0, S1, S2, S3], InitialCost, NewCost)
:-
    AgentsPos \= NewAgentsPos,
    NewCost is InitialCost + abs(AgentsPos - NewAgentsPos)
.

% When the agent has cleaned
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
