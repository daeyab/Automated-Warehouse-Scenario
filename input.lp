% node N is in (X, Y)
node(N) :- init(object(node, N), value(at, pair(X, Y))).
% highway H is in (X, Y)
highway(H) :- init(object(highway, H), value(at, pair(X, Y))).
% picking-station PS is in (X, Y)
pickingStation(PS) : :- init(object(pickingStation, PS), value(at, pair(X, Y))).
% robot R is in (X, Y)
robot(R) :- init(object(robot, R), value(at, pair(X, Y))).
% shelf S is in (X, Y)
shelf(S) :- init(object(shelf, S), value(at, pair(X, Y))).
% product P is in shelf S with count CNT
product(P) :- init(object(product, P), value(on, pair(S, CNT))).
% order N is for picking-station PS
order(O) :- init(object(order, O), value(pickingStation, PS)).

% node N is at pair (X, Y)
nodeAt(N, pair(X, Y) :- init(object(node, N), value(at, pair(X, Y))).
pair(X, Y) :- init(object(node, N), value(at, pair(X, Y))).
% picking-station PS is at node N where is (X, Y)
pickingStationAt(PS, N) :- init(object(pickingStation, PS), value(at, pair(X, Y))), init(object(node, N), value(at, pair(X, Y))).
% robot R is at (X, Y) at time 0
robotAt(R, object(node, N), 0) :- init(object(robot, R), value(at, pair(X, Y))), nodeAt(N, pair(X, Y))).
% shelf S is at (X, Y) at time 0
shelfAt(S, object(node, N), 0) :- init(object(shelf, S), value(at, pair(X, Y))), nodeAt(N, pair(X, Y))).
% product P is in shelf S with count CNT at time 0
productAt(P, S, TOTAL_CNT, 0) :- init(object(product, P), value(on, pair(S, TOTAL_CNT))).
% order O needs Product P with count CNT to picking-station PS at time 0
orderInfo(O, object(node, N), has(P, CNT), 0) :- init(object(order, O), value(pickingStation, PS)), pickingStationAt(PS, N), init(object(order, O), value(line, pair(P, CNT))).
