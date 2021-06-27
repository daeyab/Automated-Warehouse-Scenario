% node N is in (X, Y)
node(N) :- init(object(node, N), value(at, pair(X, Y))).
% highway N is in (X, Y)
highway(N) :- init(object(highway, N), value(at, pair(X, Y))).
% pickingStation N is in (X, Y)
pickingStation(N, X, Y) : :- init(object(pickingStation, N), value(at, pair(X, Y))).
% robot N
robot(N) :- init(object(robot, N), value(at, pair(X, Y))).
% shelf N
shelf(N) :- init(object(shelf, N), value(at, pair(X, Y))).
% product N is in shelf S with count CNT
product(N) :- init(object(product, N), value(on, pair(S, CNT))).
% order N is for picking station TO
order(N, TO) :- init(object(order, N), value(pickingStation, TO)).

% order N needs P with count CNT
orderInfo(N, P, CNT) :- init(object(order, N), value(line, pair(P, CNT))).
% robot N is in (X, Y) at time 0
robotAt(N, X, Y, 0) :- init(object(robot, N), value(at, pair(X, Y))).
% shelf N is in (X, Y) at time 0
shelfAt(N, X, Y, 0) :- init(object(shelf, N), value(at, pair(X, Y))).
% product N is in shelf S with count CNT at time T
product(N, S, 0) :- init(object(product, N), value(on, pair(S, CNT))).
% product P is in shelf S with count CNT at time 0
productInShelf(S, P, CNT, 0) :- init(object(product, P), value(on, pair(S, CNT))).
% order N is for picking station TO
order(N, TO) :- init(object(order, N), value(pickingStation, TO)).
%order N needs Product P with count CNT at time 0
orderInfo(N, P, CNT, 0) :- init(object(order, N), value(line, pair(P, CNT))).


% commonsense law of inertia
{ robotAt(N, X, Y, T) } 1 :- robotAt(N, X, Y, T-1), T = 1..t.
{ shelfAt(S, X, Y, T) } 1 :- shelfAt(S, X, Y, T-1), T = 1..t.
{ productInShelf(S, P, CNT, T) } 1 :- productInShelf(S, P, CNT, T-1), T = 1..t.
{ orderInfo(N, P, CNT, T) } 1 :- orderInfo(N, P, CNT, T-1), T = 1..t.