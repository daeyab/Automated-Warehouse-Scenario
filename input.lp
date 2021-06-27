%%%%%%
% node N is in (Y, X)
node(N) :- init(object(node, N), value(at, pair(Y, X))).
% highway N is in (Y, X)
highway(N) :- init(object(highway, N), value(at, pair(Y, X))).
% pickingStation N is in (Y, X)
pickingStation(N, Y, X) : :- init(object(pickingStation, N), value(at, pair(Y, X))).
% robot N
robot(N) :- init(object(robot, N), value(at, pair(Y, X))).
% shelf N
shelf(N) :- init(object(shelf, N), value(at, pair(Y, X))).
% product N is in shelf S with count CNT
product(N) :- init(object(product, N), value(on, pair(S, CNT))).
% order N is for picking station TO
order(N, TO) :- init(object(order, N), value(pickingStation, TO)).

% node N is at N
% order N needs P with count CNT
orderInfo(N, P, CNT) :- init(object(order, N), value(line, pair(P, CNT))).
% robot N is in (Y, X) at time 0
robotAt(N, Y, X, 0) :- init(object(robot, N), value(at, pair(Y, X))).
% shelf N is in (Y, X) at time 0
shelfAt(N, Y, X, 0) :- init(object(shelf, N), value(at, pair(Y, X))).
% product N is in shelf S with count CNT at time T
product(N, S, 0) :- init(object(product, N), value(on, pair(S, CNT))).
% product P is in shelf S with count CNT at time 0
productInShelf(S, P, CNT, 0) :- init(object(product, P), value(on, pair(S, CNT))).
% order N is for picking station TO
order(N, TO) :- init(object(order, N), value(pickingStation, TO)).
%order N needs Product P with count CNT at time 0
orderInfo(N, P, CNT, 0) :- init(object(order, N), value(line, pair(P, CNT))).


% commonsense law of inertia
{ robotAt(N, Y, X, T) } 1 :- robotAt(N, Y, X, T-1), T = 1..t.
{ shelfAt(S, Y, X, T) } 1 :- shelfAt(S, Y, X, T-1), T = 1..t.
{ productInShelf(S, P, CNT, T) } 1 :- productInShelf(S, P, CNT, T-1), T = 1..t.
{ orderInfo(N, P, CNT, T) } 1 :- orderInfo(N, P, CNT, T-1), T = 1..t.