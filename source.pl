
# State representation:
    # 
# [
#     AgentPosition,
#     StateCost,
#     Square0IsDirty,
#     Square1IsDirty,
#     Square2IsDirty,
#     Square3IsDirty
# ]
#
# Example: [2, 10, 1, 1, 0, 0]
# 

best_first([], _ , _ )
:-
    write('Solução não encontrada'), nl
.

best_first([[_, G, _, _]|T], C, [_, G, _, _])
:-
    write('open: '), printlist([ G | T ] ), nl,
    write('open: '), printlist([ G | T ] ), nl,
    write('closed: '), printlist(C), nl,
    write('OBJETIVO: '), write(G), nl,
    write('Solução encontrada'), nl
.

best_first([[F, S, D, H]|T], C, [_,G,_,_])
:-
    write('open: '), printlist([ S | T ] ), nl,
    write('closed: '), printlist(C), nl,
    findall(X, moves([F, S, D, H], T, C, X), List),
    write('nos gerados: '), printlist(List), nl,
    sort(List, NewList),
    merge(T, NewList, O),
    best_first(O, [[F, S, D, H] | C], [G, _, _, _])
.

move([AgentPosition, StateCost | T], Direction, NewState)
:-
    Direction = left
    ( AgentPosition =:= 0 ; AgentPosition =:= 2 ),
    NewState = [AgentPosition +1, StateCost +2 | T]
    ;
    Direction = right
    ( AgentPosition =:= 1 ; AgentPosition =:= 3 ),
    NewState = [AgentPosition -1, StateCost +2 | T]
    ;
    Direction = up
    ( AgentPosition =:= 2 ; AgentPosition =:= 3 ),
    NewState = [AgentPosition -2, StateCost +3 | T]
    ;
    Direction = down
    ( AgentPosition =:= 0 ; AgentPosition =:= 1 ),
    NewState = [AgentPosition +2, StateCost +3 | T]
    ;
    write('Invalid movement: '), printlist([AgentPosition | T]),
    write(Direction),
    NewState = []
.
