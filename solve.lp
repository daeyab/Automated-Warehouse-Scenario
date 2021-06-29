#include "input.lp"
#include "count.lp"

% #const n = 50.
% 움직임 네방향 존재
move(1, 0). move(-1, 0). move(0, 1). move(0, -1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% robot can do one action at one time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% robot R move at time T
{moveRobot(R, move(DY, DX), T) : move(DY, DX))} 1 :- R = 1..RNUM, cntRobots(RNUM), T = 1..t-1.
% robot R pick up at time T
{pickUp(R, S, T) : shelf(S)} 1 :- R = 1..RNUM, cntRobots(RNUM), T = 1..t-1.
% robot R put down at time T
{putDown(R, S, T) : shelf(S)} 1 :- R = 1..RNUM, cntRobots(RNUM), T = 1..t-1.
% robot R deliver product P * CNT of order O at time T
{deliverProduct(R, O, S, P, CNT, T) : orderInfo(O, object(node, N), has(PR, TOTAL_T), T), productAt(P, S, TOTAL_CNT, T) CNT = 1..TOTAL_CNT} 1 :- R = 1..RNUM, cntRobots(RNUM), T = 1..t-1.

% Define output actions
occurs(object(robot, R), move(DX, DY), T) :- moveRobot(R, move(DY, DX), T).
occurs(object(robot, R), pickup, T) :- pickUp(R, _, T).
occurs(object(robot, R), putdown, T) :- putDown(R, _, T).
occurs(object(robot, R), deliver(O, P, CNT), T) :- deliverProduct(R, O, S, P, CNT, T).

%%%%%%%%%%%%
%constraints
%%%%%%%%%%%%
    상태 제약
길
    스테이션은 고속도로에 있으면 안됨
    상자는 고속도로에 있으면 안됨
로봇
    한 로봇은 두 곳에 있을 수 없음
    두 로봇은 한 곳에 같이 있을 수 없음
    로봇 서로 자리를 바꿀 수 없음 (충돌 방지)
상자
    한 상자는 두 곳에 있을 수 없음
    두 상자는 한 곳에 같이 있을 수 없음
    한 상자는 두 로봇이 들 수 없음
    두 상자는 한 로봇에 있을 수 없음
    한 상자는 로봇에 있고 동시에 바닥(노드)에 있을 수 없음
    
로봇이 움직일 때
    충돌 있으면 안 됨
    상하좌우만 움직임
    짐을 들고 있으면 안됨
    상자를 들고 있으면 같이 움직임
    상자가 움직이면 안의 물품도 움직임
    
짐 들 때
    로봇이 짐을 들고 있으면 안됨


짐 제출할 때
    로봇이 해당 스테이션에 있어야 함
    그 스테이션의 번호와 주문 스테이션 번호가 같아야 함
    주문의 양 보다 더 제출하면 안됨
    상품의 양 보다 더 제출하면 안됨

액션 제약
로봇이 움직이는 것
짐을 드는 것
짐을 내리는 것
짐을 배달하는 것 2줄

인 커먼오브센스 5개


골 선언

%%%%%%%%%%%%%%%%%%%%%%

로봇은 영역을 벗어나면 안됨
로봇은 움직이면 한칸 움직임
로봇은 움직인 곳에서 움직인 곳으로 움직일 수 없음 ?

로봇이 서랍을 들고 있다면 다른 서랍 밑으로는 지나갈 수 없음
로봇이 서랍을 들고 있다면 다른 서랍은 들 수 없음
= 로봇은 서랍을 최대 하나만 들 수 있음
= 로봇은 서랍을 들고 있지 않을 때 서랍을 들 수 있음
로봇은 서랍을 들고 있을 때만 서랍을 내려 놓을 수 있음
로봇은 서랍을 들고 있을 때, 서랍에 있는 짐들은 같이 옮겨짐
로봇은 서랍을 내릴 때, 서랍에 있는 짐들은 같이 내려짐


:- move