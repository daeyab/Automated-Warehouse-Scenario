% node N is in (X, Y)
node(N) :- init(object(node, N), value(at, pair(X, Y))).
% highway N is in (X, Y)
highway(H) :- init(object(highway, H), value(at, pair(X, Y))).
% pickingStation N is in (X, Y)
pickingStation(PS, X, Y) : :- init(object(pickingStation, PS), value(at, pair(X, Y))).
% robot N
robot(R) :- init(object(robot, R), value(at, pair(X, Y))).
% shelf N
shelf(S) :- init(object(shelf, S), value(at, pair(X, Y))).
% product N is in shelf S with count CNT
product(P) :- init(object(product, P), value(on, pair(S, CNT))).
% order N is for picking station TO
order(O, TO) :- init(object(order, O), value(pickingStation, TO)).

% order O needs P with count CNT
orderInfo(O, P, CNT) :- init(object(order, O), value(line, pair(P, CNT))).
% robot R is in (X, Y) at time 0
robotAt(R, X, Y, 0) :- init(object(robot, R), value(at, pair(X, Y))).
% shelf S is in (X, Y) at time 0
shelfAt(S, X, Y, 0) :- init(object(shelf, S), value(at, pair(X, Y))).
% product P is in shelf S with count CNT at time T
product(P, S, 0) :- init(object(product, P), value(on, pair(S, CNT))).
% product P is in shelf S with count CNT at time 0
productInShelf(S, P, CNT, 0) :- init(object(product, P), value(on, pair(S, CNT))).
% order O is for picking station TO
order(O, TO) :- init(object(order, O), value(pickingStation, TO)).
%order O needs Product P with count CNT at time 0
orderInfo(O, P, CNT, 0) :- init(object(order, O), value(line, pair(P, CNT))).


% commonsense law of inertia
{ robotAt(N, X, Y, T) } 1 :- robotAt(N, X, Y, T-1), T = 1..t.
{ shelfAt(S, X, Y, T) } 1 :- shelfAt(S, X, Y, T-1), T = 1..t.
{ productInShelf(S, P, CNT, T) } 1 :- productInShelf(S, P, CNT, T-1), T = 1..t.
{ orderInfo(N, P, CNT, T) } 1 :- orderInfo(N, P, CNT, T-1), T = 1..t.