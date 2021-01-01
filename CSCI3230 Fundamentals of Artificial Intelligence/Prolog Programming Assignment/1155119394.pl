goal([1,7,13,19,25]).
goal([5,11,17,23,29]).
goal([8,9,10,11,12]).
goal([13,14,15,16,17]).
goal([1,2,3,4,5]).
goal([5,10,15,20,25]).
goal([8,15,22,29,36]).
goal([14,15,16,17,18]).
goal([1,8,15,22,29]).
goal([6,12,18,24,30]).
goal([9,15,21,27,33]).
goal([19,20,21,22,23]).
goal([2,8,14,20,26]).
goal([6,11,16,21,26]).
goal([10,16,22,28,34]).
goal([20,21,22,23,24]).
goal([2,3,4,5,6]).
goal([7,13,19,25,31]).
goal([11,17,23,29,35]).
goal([25,26,27,28,29]).
goal([2,9,16,23,30]).
goal([7,8,9,10,11]).
goal([11,16,21,26,31]).
goal([26,27,28,29,30]).
goal([3,9,15,21,27]).
goal([7,14,21,28,35]).
goal([12,18,24,30,36]).
goal([31,32,33,34,35]).
goal([4,10,16,22,28]).
goal([8,14,20,26,32]).
goal([12,17,22,27,32]).
goal([32,33,34,35,36]).

winning(Current, Opponent):-
    goal(Scenario),
    intersection(Scenario, Current, I),
    length(I, Count),
    Count is 4,
    subtract(Scenario, I, Result),
    intersection(Result, Opponent, Miss),
    length(Miss, MissSize),
    MissSize == 0.

threatening(Board, CurrentPlayer, ThreatsCount):-
    Board = board(B, R),
    (CurrentPlayer == black -> (Current = B, Opponent = R); (Current = R, Opponent = B)),
    aggregate_all(count, winning(Opponent, Current), ThreatsCount).

emptyBoard([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36]).

emptyPosition(Board, X):-
    Board = board(B, R),
    emptyBoard(Empty),
    union(B, R, Y),
    subtract(Empty, Y, Z),
    member(X, Z).

quadrant(top-left).
quadrant(top-right).
quadrant(bottom-left).
quadrant(bottom-right).

rotate(Quadrant, Rotation, Current, Opponent, CurrentRotate, OpponentRotate):-
    Rotation == clockwise ->  (clockwise(Quadrant, Current, Opponent, CurrentRotate, OpponentRotate), !); (antiClockwise(Quadrant, Current, Opponent, CurrentRotate, OpponentRotate), !).

clockwise(Quadrant, Current, Opponent, CurrentRotate, OpponentRotate):-
    clockwiseStrategy(Quadrant, Current, CurrentRotate),
    clockwiseStrategy(Quadrant, Opponent, OpponentRotate).

antiClockwise(Quadrant, Current, Opponent, CurrentRotate, OpponentRotate):-
    antiClockwiseStrategy(Quadrant, Current, CurrentRotate),
    antiClockwiseStrategy(Quadrant, Opponent, OpponentRotate).

positionRotate(_, _, [], []).
positionRotate(P, N, [P|T], [N|T2]):-
    positionRotate(P, N, T, T2).
positionRotate(P, N, [H|T], [H|T2]):-
    H \= P,
    positionRotate(P, N, T, T2).

absPosition([], []).
absPosition([H|Position], [H2|Abs]):-
    H2 is abs(H),
    absPosition(Position, Abs),
    !.

rotation(clockwise).
rotation(anti-clockwise).

clockwiseStrategy(Quadrant, Position, PositionRotate):-
    Quadrant == top-left -> (positionRotate(1, -3, Position, Temp1), positionRotate(2, -9, Temp1, Temp2), positionRotate(3, -15, Temp2, Temp3), positionRotate(7, -2, Temp3, Temp4), positionRotate(9, -14, Temp4, Temp5), positionRotate(13, -1, Temp5, Temp6), positionRotate(14, -7, Temp6, Temp7), positionRotate(15, -13, Temp7, Temp8), absPosition(Temp8, PositionRotate), !);
    Quadrant == top-right ->  (positionRotate(4, -6, Position, Temp1), positionRotate(5, -12, Temp1, Temp2), positionRotate(6, -18, Temp2, Temp3), positionRotate(10, -5, Temp3, Temp4), positionRotate(12, -17, Temp4, Temp5), positionRotate(16, -4, Temp5, Temp6), positionRotate(17, -10, Temp6, Temp7), positionRotate(18, -16, Temp7, Temp8), absPosition(Temp8, PositionRotate), !);
    Quadrant == bottom-left -> (positionRotate(19, -21, Position, Temp1), positionRotate(20, -27, Temp1, Temp2), positionRotate(21, -33, Temp2, Temp3), positionRotate(25, -20, Temp3, Temp4), positionRotate(27, -32, Temp4, Temp5), positionRotate(31, -19, Temp5, Temp6), positionRotate(32, -25, Temp6, Temp7), positionRotate(33, -31, Temp7, Temp8), absPosition(Temp8, PositionRotate), !);
    positionRotate(22, -24, Position, Temp1), positionRotate(23, -30, Temp1, Temp2), positionRotate(24, -36, Temp2, Temp3), positionRotate(28, -23, Temp3, Temp4), positionRotate(30, -35, Temp4, Temp5), positionRotate(34, -22, Temp5, Temp6), positionRotate(35, -28, Temp6, Temp7), positionRotate(36, -34, Temp7, Temp8), absPosition(Temp8, PositionRotate), !.

antiClockwiseStrategy(Quadrant, Position, PositionRotate):-
    Quadrant == top-left -> (positionRotate(3, -1, Position, Temp1), positionRotate(9, -2, Temp1, Temp2), positionRotate(15, -3, Temp2, Temp3), positionRotate(2, -7, Temp3, Temp4), positionRotate(14, -9, Temp4, Temp5), positionRotate(1, -13, Temp5, Temp6), positionRotate(7, -14, Temp6, Temp7), positionRotate(13, -15, Temp7, Temp8), absPosition(Temp8, PositionRotate), !);
    Quadrant == top-right -> (positionRotate(6, -4, Position, Temp1), positionRotate(12, -5, Temp1, Temp2), positionRotate(18, -6, Temp2, Temp3), positionRotate(5, -10, Temp3, Temp4), positionRotate(17, -12, Temp4, Temp5), positionRotate(4, -16, Temp5, Temp6), positionRotate(10, -17, Temp6, Temp7), positionRotate(16, -18, Temp7, Temp8), absPosition(Temp8, PositionRotate), !);
    Quadrant == bottom-left -> (positionRotate(21, -19, Position, Temp1), positionRotate(27, -20, Temp1, Temp2), positionRotate(33, -21, Temp2, Temp3), positionRotate(20, -25, Temp3, Temp4), positionRotate(32, -27, Temp4, Temp5), positionRotate(19, -31, Temp5, Temp6), positionRotate(25, -32, Temp6, Temp7), positionRotate(31, -33, Temp7, Temp8), absPosition(Temp8, PositionRotate), !);
    positionRotate(24, -22, Position, Temp1), positionRotate(30, -23, Temp1, Temp2), positionRotate(36, -24, Temp2, Temp3), positionRotate(23, -28, Temp3, Temp4), positionRotate(35, -30, Temp4, Temp5), positionRotate(22, -34, Temp5, Temp6), positionRotate(28, -35, Temp6, Temp7), positionRotate(34, -36, Temp7, Temp8), absPosition(Temp8, PositionRotate), !.

pentago_ai(Board, CurrentPlayer, BestMove, NextBoard) :-
    Board = board(B, R),
    (CurrentPlayer == black -> (Current = B, Opponent = R); (Current = R, Opponent = B)),
    rotation(Rotation),
    quadrant(Quadrant),
    emptyPosition(Board, EmptyPos),
    append([EmptyPos], Current, CurrentNew),
    goal(Scenario),
    intersection(CurrentNew, Scenario, I),
    length(I, Count),
    Count is 5,
    BestMove = move(EmptyPos, Rotation, Quadrant),
    sort(CurrentNew,CurrentSort),
    (CurrentPlayer == black -> NextBoard = board(CurrentSort, Opponent); NextBoard = board(Opponent, CurrentSort)),
    !.

pentago_ai(Board,CurrentPlayer,BestMove,NextBoard) :-
    Board = board(B, R),
    (CurrentPlayer == black -> (Current = B, Opponent = R); (Current = R, Opponent = B)),    %Board = board(BlackL,RedL),
    rotation(Rotation),
    quadrant(Quadrant),
    emptyPosition(Board, EmptyPos),
    append([EmptyPos], Current, CurrentNew),
    rotate(Quadrant, Rotation, CurrentNew, Opponent, CurrentRotate, OpponentRotate),
    goal(Scenario),
    intersection(CurrentRotate, Scenario, I),
    length(I, Count),
    Count is 5,
    BestMove = move(EmptyPos, Rotation, Quadrant),
    sort(CurrentRotate, CurrentSort),
    sort(OpponentRotate, OpponentSort),
    (CurrentPlayer == black -> NextBoard = board(CurrentSort, OpponentSort); NextBoard = board(OpponentSort, CurrentSort)),
    !.

pentago_ai(Board,CurrentPlayer,BestMove,NextBoard) :-
    Board = board(B, R),
    (CurrentPlayer == black -> (Current = B, Opponent = R); (Current = R, Opponent = B)),    %Board = board(BlackL,RedL),
    rotation(Rotation),
    quadrant(Quadrant),
    emptyPosition(Board, EmptyPos),
    append([EmptyPos], Current, CurrentNew),
    rotate(Quadrant, Rotation, CurrentNew, Opponent, CurrentRotate, OpponentRotate),
    BestMove = move(EmptyPos, Rotation, Quadrant),
    sort(CurrentRotate, CurrentSort),
    sort(OpponentRotate, OpponentSort),
    (CurrentPlayer == black -> NextBoard = board(CurrentSort, OpponentSort); NextBoard = board(OpponentSort, CurrentSort)),
    !.
