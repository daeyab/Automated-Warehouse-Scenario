% number of rows
numRows(CNT) :- CNT = #count{Y : init(object(node, N), value(at, pair(Y, X)))}.
% number of columns
numCols(CNT) :- CNT = #count{X : init(object(node, N), value(at, pair(X, Y)))}.
% number of robots
numRobots(CNT) :- CNT = #count{N : init(object(robot, N), value(at, pair(Y, X)))}.
% number of robots
numShelves(CNT) :- CNT = #count{N : init(object(robot, N), value(at, pair(Y, X)))}.