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
    write('Solucao nao encontrada'), nl,
    !
.

best_first([[F, G, D, H]|T], C, [_, G, _, _])
:-
    write('Solucao encontrada'), nl,
    
    write('Open'), nl,
    printlist([[F, G, D, H]|T]), nl,
    
    write('Closed'), nl,
    printlist(C), nl,

    write('Objetivo: '), write(G), nl,
    !
.

best_first([[F, S, D, H]|T], C, [_,G,_,_])
:-
    write('Best first em andamento'), nl,
    
    write('Atual'), nl,
    printlist([[F, S, D, H]]), nl,

    write('Open'), nl,
    printlist(T), nl,
    
    write('Closed'), nl,
    printlist(C), nl,
    
    findall(X, moves([F, S, D, H], T, C, X), List),
    
    write('Nos gerados'), nl,
    printlist(List), nl,
    
    sort(List, NewList),
    merge(T, NewList, O),
    
    best_first(O, [[F, S, D, H] | C], [_, G, _, _])
.

moves([_, S, D, _], T, C, [NF, A, ND, NH])
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
    write('['), write(AgentsPos),write(']['),write(S0), write(S1), write(S2), write(S3), write(']'),
    write(' D='), write(D),
    write(' H='), write(H),
    write(' F='), write(F),
    write(', '), printlist(T)
.

% Returns NewState, a new generated state from a current state @State.
% 
% @param State
% @param out NewState
%
%
% Right movement
% Agent is in square [0, 0] or [1, 0]
move([AgentsPos, S0, S1, S2, S3], [NewAgentsPos, S0, S1, S2, S3])
:-
    (AgentsPos = 0; AgentsPos = 2),
    NewAgentsPos is AgentsPos + 1
.

% Down movement
% Agent is in square [0, 0] or [0, 1]
move([AgentsPos, S0, S1, S2, S3], [NewAgentsPos, S0, S1, S2, S3])
:-
    (AgentsPos = 0; AgentsPos = 1),
    NewAgentsPos is AgentsPos + 2
.

% Left movement
% Agent is in square [0, 1] or [1, 1]
move([AgentsPos, S0, S1, S2, S3], [NewAgentsPos, S0, S1, S2, S3])
:-
    (AgentsPos = 1; AgentsPos = 3),
    NewAgentsPos is AgentsPos - 1
.

% Up movement
% Agent is in square [1, 0] or [1, 1]
move([AgentsPos, S0, S1, S2, S3], [NewAgentsPos, S0, S1, S2, S3])
:-
    (AgentsPos = 2; AgentsPos = 3),
    NewAgentsPos is AgentsPos - 2
.

% Cleaning
move([AgentsPos | Squares], [AgentsPos | Result])
:-
    isSquareDirty(Squares, AgentsPos, 0),
    cleanSquare(Squares, AgentsPos, 0, Result)
.

isSquareDirty([Square|_], Nth, Current)
:-
    Current =:= Nth,
    Square  =:= 1,
    !
.

isSquareDirty([_|T], Nth, Current)
:-
    Current    < Nth,
    NewCurrent is Current + 1,
    isSquareDirty(T, Nth, NewCurrent),
    !
.

cleanSquare([], _, _, Result)
:-
    Result = [], !
.

cleanSquare([Square | Squares], Nth, Current, [Square | Result])
:-
    Current \= Nth,
    NewCurrent is Current + 1,
    cleanSquare(Squares, Nth, NewCurrent, Result),
    !
.

cleanSquare([_|Squares], Nth, Current, [0 | Result])
:-
    Current =:= Nth,
    NewCurrent is Current + 1,
    cleanSquare(Squares, Nth, NewCurrent, Result),
    !
.

% Returns G(State), where G is the function cost on a given state @State.
% 
% @param State
% @param out G
%
%
% When the agent has moved...
calculaG([AgentsPos, S0, S1, S2, S3], [NewAgentsPos, S0, S1, S2, S3], InitialCost, NewCost)
:-
    NewCost is InitialCost + abs(AgentsPos - NewAgentsPos),
    AgentsPos \= NewAgentsPos,
    !
.

% When the agent has cleaned
calculaG([AgentsPos | Squares], [AgentsPos | NewSquares], InitialCost, NewCost)
:-
    Squares \= NewSquares,
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

innerCalculaH([Square | Squares], H)
:-
    innerCalculaH(Squares, InnerH),
    (Square = 1, H is InnerH + 1 ; Square = 0, H is InnerH)
.
