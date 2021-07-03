% CSE579 Fall 2019 Final Project
% James Smith, Pavan Kumar Kintali, Nilesh Mutyam, Praveen Muruganandam

% OBJECTS
node(X,Y) :- init(object(node,_),value(at,pair(X,Y))).
robot(R) :- init(object(robot,R),value(at,pair(X,Y))).
highway(X,Y) :- init(object(highway,_),value(at,pair(X,Y))).
picking_station(P,X,Y) :- init(object(pickingStation,P),value(at,pair(X,Y))).
shelf(S) :- init(object(shelf,S),value(at,pair(X,Y))).
product(I) :- init(object(product,I),value(on,pair(X,Y))).
order(O,P) :- init(object(order,O),value(pickingStation,P)).
% high way and node different

% initialize fluents
robot_at(R,X,Y,0) :- init(object(robot,R),value(at,pair(X,Y))).
shelf_at(S,X,Y,0) :- init(object(shelf,S),value(at,pair(X,Y))).
shelf_on(S,0,0) :- shelf(S).
product_on(P,S,U,0) :- init(object(product,P),value(on,pair(S,U))).
order_item_filled(O,I,0,U,0) :- init(object(order,O),value(line,pair(I,U))).
order_item(O,I) :- init(object(order,O),value(line,pair(I,CNT))).

% commonsense law of inertia
{ robot_at(R,X,Y,T) } 1 :- robot_at(R,X,Y,T-1), T = 1..t.
{ shelf_at(S,X,Y,T) } 1 :- shelf_at(S,X,Y,T-1), T = 1..t.
{ shelf_on(S,R,T) } 1 :- shelf_on(S,R,T-1), T = 1..t.
{ product_on(I,S,U,T) } 1 :- product_on(I,S,U,T-1), T = 1..t.
{ order_item_filled(O,I,C,U,T) } 1 :- order_item_filled(O,I,C,U,T-1), T = 1..t.

% objects must only exist in one location at each timestep
:- not { robot_at(R,XX,YY,T) } = 1, robot(R), T = 1..t.
:- not { shelf_at(S,XX,YY,T) } = 1, shelf(S), T = 1..t.
:- not { shelf_on(S,_,T) } = 1, shelf(S), T = 1..t.
:- not { order_item_filled(O,I,CC,UU,T) } = 1, order_item(O,I), T = 1..t.

% products must persist
:- not { product_on(I,S,_,T) } = 1, product_on(I,S,_,T-1), T = 1..t.

% shelves cannot hold negative item counts
:- product_on(P,S,U,T), U < 0, T = 1..t.

% cannot deliver more items than in the product order
:- order_item_filled(O,I,C,U,T), C > U, T = 1..t.

% ACTIONS
% each robot may only execute one action per turn
:- 2 { occurs(object(robot,R),AA,T) }, robot(R), T = 1..t.

% MOVE
move(1,0).
move(0,1).
move(-1,0).
move(0,-1).
{ occurs(object(robot,R),move(DX,DY),T) : move(DX,DY) } 1 :- robot(R), T = 1..t.

% preconditions
    % robot can only move to a valid node
:- robot_at(R,X,Y,T), not node(X,Y).
    % robots cannot occupy the same node
:- robot_at(R1,X,Y,T), robot_at(R2,X,Y,T), R1 != R2.
    % robots cannot swap places
:- robot_at(R1,X1,Y1,T), robot_at(R2,X2,Y2,T), robot_at(R2,X1,Y1,T-1), robot_at(R1,X2,Y2,T-1), R1 != R2.
    % two shelves cannot be at the same location
:- shelf_at(S1,X,Y,T), shelf_at(S2,X,Y,T), S1 != S2.

% effects
robot_at(R,X+DX,Y+DY,T) :- occurs(object(robot,R),move(DX,DY),T), robot_at(R,X,Y,T-1).
shelf_at(S,X,Y,T) :- shelf_on(S,R,T), robot_at(R,X,Y,T).

% PICKUP
{ occurs(object(robot,R),pickup,T) } 1 :- robot(R), T = 1..t.
% preconditions
    % robot must be at shelf location
:- occurs(object(robot,R),pickup,T), robot_at(R,X,Y,T-1), not shelf_at(_,X,Y,T-1). % 여기
    % robot must not be carring a shelf
:- occurs(object(robot,R),pickup,T), shelf_on(_,R,T-1).
% effects
shelf_on(S,R,T) :- occurs(object(robot,R),pickup,T), robot_at(R,X,Y,T-1), shelf_at(S,X,Y,T-1).

% DELIVER
{ occurs(object(robot,R),deliver(O,I,U),T) } 1 :- robot(R), shelf_on(S,R,T-1), product_on(I,S,U,T-1), order_item_filled(O,I,_,_,T-1), T = 1..t.
{ occurs(object(robot,R),deliver(O,I,U),T) } 1 :- robot(R), shelf_on(S,R,T-1), product_on(I,S,_,T-1), order_item_filled(O,I,CU,OU,T-1), U = OU-CU, T = 1..t.

% preconditions
    % robot must be at the picking station
:- occurs(object(robot,R),deliver(O,I,U),T), robot_at(R,X,Y,T-1), order(O,P), not picking_station(P,X,Y). %여기 
    % robot must be carrying a shelf
:- occurs(object(robot,R),deliver(_,_,_),T), not shelf_on(_,R,T-1).
    % robot must be carrying shelf that holds the product
:- occurs(object(robot,R),deliver(O,I,_),T), robot(R), shelf_on(S,R,T-1), not product_on(I,S,_,T-1).

% effects
order_item_filled(O,I,U+C,OU,T) :- occurs(object(robot,R),deliver(O,I,U),T), order_item_filled(O,I,C,OU,T-1).
product_on(I,S,SU-DU,T) :- occurs(object(robot,R),deliver(O,I,DU),T), shelf_on(S,R,T-1), product_on(I,S,SU,T-1).

% PUTDOWN
{ occurs(object(robot,R),putdown,T) } 1 :- robot(R), T = 1..t.

% preconditions
    % can only put down if robot is carrying a shelf
:- occurs(object(robot,R),putdown,T), not shelf_on(_,R,T-1).
    % cannot put down shelves in a highway
:- occurs(object(robot,R),putdown,T), robot_at(R,X,Y,T-1), highway(X,Y).

% effects
shelf_on(S,0,T) :- occurs(object(robot,R),putdown,T), shelf_on(S,R,T-1).

% GOAL
:- order_item_filled(O,I,C,U,t), C != U.
#minimize{1,T: occurs(object(robot,_),_,T)}.

#show occurs/3.{block(1..6)}.


