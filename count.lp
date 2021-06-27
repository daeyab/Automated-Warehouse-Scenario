% count number of rows
cntRows(CNT) :- CNT = #count{Y : init(object(node, N), value(at, pair(X, Y)))}.
% count number of columns
cntCols(CNT) :- CNT = #count{X : init(object(node, N), value(at, pair(X, Y)))}.
% count number of robots
cntRobots(CNT) :- CNT = #count{N : init(object(robot, N), value(at, pair(X, Y)))}.
% count number of robots
cntShelves(CNT) :- CNT = #count{N : init(object(robot, N), value(at, pair(X, Y)))}.