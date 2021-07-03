%%%%%%%%%%%%%%
% READ INPUT %
%%%%%%%%%%%%%%

% node N is in (X, Y)
node(X, Y) :- init(object(node, N), value(at, pair(X, Y))).
% robot R is in (X, Y)
robot(R) :- init(object(robot, R), value(at, pair(X, Y))).
% highway H is in (X, Y)
highway(X, Y) :- init(object(highway, H), value(at, pair(X, Y))).
% picking-station PS is in (X, Y)
pickingStation(PS, X, Y) : :- init(object(pickingStation, PS), value(at, pair(X, Y))).
% shelf S is in (X, Y)
shelf(S) :- init(object(shelf, S), value(at, pair(X, Y))).
% product P is in shelf S with count CNT
product(P) :- init(object(product, P), value(on, pair(S, CNT))).
% order O is for picking-station PS
order(O, PS) :- init(object(order, O), value(pickingStation, PS)).
