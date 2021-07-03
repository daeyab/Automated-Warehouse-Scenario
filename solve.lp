#include "input.lp".

%%%%%%%%
% goal %
%%%%%%%%

% find the minimum T which makes orderInfo CNT == TOTAL_CNT
:- orderInfo(O, P, CNT, TOTAL_CNT, t), CNT != TOTAL_CNT.
#minimize{1, T : occurs(object(robot, _), _, T)}.
#show occurs/3.

%%%%%%%%%%%%%%%%%%%%%
% initialize states %
%%%%%%%%%%%%%%%%%%%%%

% robot R is at (X, Y) at time 0
robotAtLoc(R, X, Y, 0) :- init(object(robot, R), value(at, pair(X, Y))).
% shelf S is at (X, Y) at time 0
shelfAtLoc(S, X, Y, 0) :- init(object(shelf, S), value(at, pair(X, Y))).
% shelf on surface when time 0
shelfOnRobot(S, surface, 0) :- shelf(S).
% product P is in shelf S with count CNT at time 0
productAtShelf(P, S, CNT, 0) :- init(object(product, P), value(on, pair(S, CNT))).
% order O has 0 of TOTAL_CNT with product P at time 0
orderInfo(O, P, 0, TOTAL_CNT, 0) :- init(object(order, O), value(line, pair(P, TOTAL_CNT))).
% order O has product P
orderProducts(O, P) :- init(object(order, O), value(line, pair(P, CNT))).


%%%%%%%%%%%%%%%%%%
% define actions %
%%%%%%%%%%%%%%%%%%

% 4 move directions.
move(1, 0). move(-1, 0). move(0, 1). move(0, -1).
% robot can move at most once at time T
{occurs(object(robot, R), move(DX, DY), T) : move(DX, DY)} 1 :- robot(R), T = 1..t.
% robot can pick up at most once at time T
{occurs(object(robot, R), pickUp, T)} 1 :- robot(R), T = 1..t.
% robot can put down at most once at time T
{occurs(object(robot, R), putDown, T) } 1 :- robot(R), T = 1..t.
% robot can deliver all in the shelf at most once at time T
{occurs(object(robot, R), deliver(O, P, CNT), T) } 1 :- robot(R), shelfOnRobot(S, R, T-1), productAtShelf(P, S, CNT, T-1), orderInfo(O, P, _, _, T-1), T = 1..t.
% robot can deliver some in the shelf at most once at time T
{occurs(object(robot, R), deliver(O, P, CNT), T) } 1 :- robot(R), shelfOnRobot(S, R, T-1), productAtShelf(P, S, _, T-1), orderInfo(O, P, EXIST_CNT, TOTAL_CNT, T-1), CNT = TOTAL_CNT-EXIST_CNT, T = 1..t.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% state / action constraints %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% no multiple actions with robot R in time t
:- 2 {occurs(object(robot, R), ACTION, T)}, robot(R), T = 1..t.

% only in one location at time t
% robot
:- not {robotAtLoc(R, X, Y, T)} = 1, robot(R), T = 1..t.
% shelf
:- not {shelfAtLoc(S, X, Y, T)} = 1, shelf(S), T = 1..t.
% shelfOnRobot
:- not {shelfOnRobot(S, _, T)} = 1, shelf(S), T = 1..t.
% orderInfo
:- not {orderInfo(O, P, CNT, TOTAL_CNT, T)} = 1, orderProducts(O, P), T = 1..t. 

% product can't be disappeared
:- not {productAtShelf(P, S, _, T)} = 1, productAtShelf(P, S, _, T-1), T = 1..t.

% no shelfs having negative counts
:- productAtShelf(P, S, CNT, T), CNT < 0, T = 1..t.

% no order count greater than total order count
:- orderInfo(O, P, CNT, TOTAL_CNT, T), TOTAL_CNT < CNT, T = 1..t.


%%%%%%%%%%%%%%%%%
% preconditions %
%%%%%%%%%%%%%%%%%

% move %
% no robot at unvalid location
:- robotAtLoc(R, X, Y, T), not node(X, Y).
% no two robot at same location concurrently
:- robotAtLoc(R1, X, Y, T), robotAtLoc(R2, X, Y, T), R1 != R2.
% no robot swapping location concurrently
:- robotAtLoc(R1, X2, Y2, T), robotAtLoc(R2, X1, Y1, T), robotAtLoc(R1, X1, Y1, T-1), robotAtLoc(R2, X2, Y2, T-1), R1 != R2.

% shelf %
% no two shelves at same location concurrently
:- shelfAtLoc(S1, X, Y, T), shelfAtLoc(S2, X, Y, T), S1 != S2.

% pick up %
% no pick up when robot are not at the shelf location
:- occurs(object(robot, R), pickUp, T), robotAtLoc(R, X, Y, T-1), not shelfAtLoc(_, X, Y, T-1).
% no pick up when robot already has a shelf
:- occurs(object(robot, R), pickUp, T), shelfOnRobot(_, R, T-1).

% deliver %
% no deliver when robot is not at picking station
:- occurs(object(robot, R), deliver(O, P, CNT), T), order(O, PS), pickingStation(PS, X, Y), not robotAtLoc(R, X, Y, T-1).
% no deliver when robot doesn't has a shelf
:- occurs(object(robot, R), deliver(_, _, _), T), not shelfOnRobot(_, R, T-1).
% no deliver when robot has a shelf with no product which order needs
:- occurs(object(robot, R), deliver(O, P, _), T), robot(R), shelfOnRobot(S, R, T-1), not productAtShelf(P, S, _, T-1).

% put down %
% no put down at highway
:- occurs(object(robot, R), putDown, T), robotAtLoc(R, X, Y, T-1), highway(X, Y).
% no put down when robot don't has a shelf
:- occurs(object(robot, R), putDown, T), not shelfOnRobot(_, R, T-1).

%%%%%%%%%%%%%%%%%%
% action effects %
%%%%%%%%%%%%%%%%%%

% robot moving effect
robotAtLoc(R, X+DX, Y+DY, T) :- occurs(object(robot, R), move(DX, DY), T), robotAtLoc(R, X, Y, T-1).

% shelf moving sub effect by robot moving effect
shelfAtLoc(S, X, Y, T) :- robotAtLoc(R, X, Y, T), shelfOnRobot(S, R, T).

% pick up effect
shelfOnRobot(S, R, T) :- occurs(object(robot, R), pickUp, T), robotAtLoc(R, X, Y, T-1), shelfAtLoc(S, X, Y, T-1).

% deliver effect
productAtShelf(P, S, REMAINED_CNT-CNT, T) :- occurs(object(robot, R), deliver(O, P, CNT), T), shelfOnRobot(S, R, T-1), productAtShelf(P, S, REMAINED_CNT, T-1).
orderInfo(O, P, REMAINED_CNT+CNT, TOTAL_CNT, T) :- occurs(object(robot, R), deliver(O, P, CNT), T), orderInfo(O, P, REMAINED_CNT, TOTAL_CNT, T-1).

% put down effect
shelfOnRobot(S, surface, T) :- occurs(object(robot, R), putDown, T), shelfOnRobot(S, R, T-1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% commonsense Law of Inertia %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% robotAtLoc
{robotAtLoc(R, X, Y, T)} 1 :- robotAtLoc(R, X, Y, T-1), T = 1..t.
% shelfAtLoc
{shelfAtLoc(S, X, Y, T)} 1 :- shelfAtLoc(S, X, Y, T-1), T = 1..t.
% shelfOnRobot
{shelfOnRobot(S, R, T)} 1 :- shelfOnRobot(S, R, T-1), T = 1..t.
% product P is in shelf S with count CNT at time 0
{productAtShelf(P, S, CNT, T)} 1 :- productAtShelf(P, S, CNT, T-1), T = 1..t.
% order O has 0 of TOTAL_CNT with product P at time 0
{orderInfo(O, P, CNT, TOTAL_CNT, T)} 1 :- orderInfo(O, P, CNT, TOTAL_CNT, T-1), T = 1..t.