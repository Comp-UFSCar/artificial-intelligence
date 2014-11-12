/**
 * source.pl
 *  
 * Describes a solution for the dust cleaner 
 * problem in an 2x2 space using A* algorithm.
 *
 * @author lucasdavid
 *
 */

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

/**
 *
 * Moves agent from @AgentPosition to a new position, according with the movement 
 * specified in @Direction, and creates a new state @NewState, with the updated position.
 *
 * @param State
 * @param Direction
 * @param out NewState
 *
 */
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

/**
 *
 * Calculates the function F = G(State) + H(State)
 * 
 * @param State
 * @param out F
 *
 */
calculaF(State, F)
:-
    calculaG(State, G),
    calculaH(State, H),
    F = G + H
.

/**
 *
 * Returns G(State), where G is the function cost on a given state @State.
 * 
 * @param State
 * @param out G
 *
 */
calculaG([AgentPosition, StateCost, Squares], G)
    :- G = StateCost .

/**
 *
 * Calculates the heuristic function H.
 * H(State) = n, where @n is the number of unclean squares in a given state @State.
 * 
 * @param State
 * @param out F
 *
 */
calculaH([Agent | Squares], H)
    :- innerCalculaH(Squares, H) .

innerCalculaH([], H)
    :- H = 0 .

innerCalculaH([Square | T], H)
:-
    innerCalculaH(T, InnerH),
    (
        Square = 1 , H = InnerH + 1 ;
        Square = 0 , H = InnerH
    )
.
