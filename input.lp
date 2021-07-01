% node N is in (X, Y)
node(N, X, Y) :- init(object(node, N), value(at, pair(X, Y))).
% robot R is in (X, Y)
robot(R) :- init(object(robot, R), value(at, pair(X, Y))).
% highway H is in (X, Y)
highway(H, X, Y) :- init(object(highway, H), value(at, pair(X, Y))).
% picking-station PS is in (X, Y)
pickingStation(PS, X, Y) : :- init(object(pickingStation, PS), value(at, pair(X, Y))).
% shelf S is in (X, Y)
shelf(S) :- init(object(shelf, S), value(at, pair(X, Y))).
% product P is in shelf S with count CNT
product(P) :- init(object(product, P), value(on, pair(S, CNT))).
% order O is for picking-station PS
order(O, PS) :- init(object(order, O), value(pickingStation, PS)).
% order O has product P
orderProducts(O, P) :- init(object(order, O), value(line, pair(P, CNT)))


% robot R is at (X, Y) at time 0
robotAt(R, X, Y, 0) :- init(object(robot, R), value(at, pair(X, Y))).
% shelf S is at (X, Y) at time 0
shelfAt(S, X, Y, 0) :- init(object(shelf, S), value(at, pair(X, Y))).
% shelf has 0 products when time 0
shelfHas(S, 0, 0) :- shelf(S).
% product P is in shelf S with count CNT at time 0
productAt(P, S, CNT, 0) :- init(object(product, P), value(on, pair(S, CNT))).
% order O has 0 of TOTAL_CNT with product P at time 0
orderInfo(O, P, 0, TOTAL_CNT, 0) :- init(object(order, O), value(line, pair(P, TOTAL_CNT))).
