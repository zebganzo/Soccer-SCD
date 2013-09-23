/***************************************************************************************************************
 *												GAME STATUS FACTS											   *
 **************************************************************************************************************/
% Field coordinates 
% field(
%	position(X1,Y1), 																lower left corner
%	position(X2,Y1), 																lower right corner
%	position(X1,Y2), 																upper left corner
%	position(X2,Y2))																upper right corner
:- dynamic(field/4).
field(position(1,1), position(51,1), position(1,33), position(51,33)).

% Midfield coordinates
midfield_position(26,17).

% Ball "safe zone" for inactive balls. Corner, free kick, penalty... events cannot be started unless every player is outside this zone
% ball_safe_zone(
%	Width)																			radius of the zone	
ball_safe_zone(4).	

/***************************************************************************************************************
 *												UTILITY RULES												   *
 **************************************************************************************************************/

% adds element X to list L, resulting in list [X|L]
add(X, L, [X|L]).

% distance from location: returns the smaller number between X and Y. MinLocation is the location associated with such number
% min_from_location(
%	X,																				% X  
%	Y,																				% Y
%	Min,																			% equal to the smaller between X and Y
%	Location1,																		% Location associated to X
%	Location2,																		% Location associated to Y
%	MinLocation)																	% equal to Location1 if X is the smaller, otherwise equal to Location2
min_from_location(X, Y, X, Location1, _, Location1) :- X < Y, !.
min_from_location(_, Y, Y, _, Location2, Location2).

% Compute difference between a pair of coordinates
% distance(
%	position(X,Y),																	% position 1
%	position(Z,W),																	% position 2
%	Distance)																		% distance between position 1 and position 2
% sqrt( (Z-X)^2 + (W-Y)^2 )
distance(position(X,Y), position(Z,W), Distance) :- 
	DiffX is (Z - X)**2,
	DiffY is (W - Y)**2,
	sqrt((DiffX + DiffY), Distance).
%	round(FloatDistance, Distance).													% round the result to the nearest integer

% returns the Y coordinate of a Shot action, randomly selected in the goal height range (Y2-Y1+1)
% shotY(
%	TargetY,																		% Y coordinate of the shot
%	Team)																			% player's team
shotY(TargetY) :-
	goal_position(position(_,Y1), position(_,Y2)),		
	Width is Y2 - Y1 + 1,															% calculates the width of the goal
	Offset is (Y2-Y1)/2,															% 
	Random is random(Width),													    % random number in range Y2-Y1+1 (goal width)
	TargetY is 																		% the final Y coordinate of the shot is
	((Y1+Y2)/2) 																	% the goal center 
	+ 																				% plus
	(Random-Offset).									 							% random number minus the offset (+/- integer) because 
																					% from the center of the goal we can move up or down 	

% Finds the position of the closest team mate to the goal
% min_distance_from_goal(
%	PlayersList,																	% list of players
%	Target,																			% player who will be the target of the pass action
%	Min)																			% distance of the player 'Target' from the goal
min_distance_from_goal([],_,1000).													% boundary case: empty list

min_distance_from_goal([Head|Tail], Target, Min) :-									% general case: non-empty list of team mates
	min_distance_from_goal(Tail, Tar, CurrentMin),									% recursive call to reach the end of the players' list
	goal_position(position(GoalX, Y1), position(_,Y2)),								% get goal position
	GoalY is (Y1+Y2)/2,
	distance(Head, position(GoalX,GoalY), Distance),								% compute distance from goal for the player 'Head' of the list
	min_from_location(																% finds the minimum distance between Distance and Min
		Distance, 																	% Distance from the goal of player 'Head'
		CurrentMin, 																% Distance from the goal of the current team mate closer to the goal 
		Min, 													
		Head, 																		% Head of the list of team mates
		Tar, 																		% Current team mate closer to the goal
		Target).	

% Finds the position of the closest team mate to the goal
% min_distance_from_goal(
%	PlayersList,																	% list of players
%	Target,																			% player who will be the target of the pass action
%	Min)																			% distance of the player 'Target' from the goal
min_distance_from_me([],_,1000).													% boundary case: empty list

min_distance_from_me([Head|Tail], Target, Min) :-									% general case: non-empty list of team mates
	min_distance_from_me(Tail, Tar, CurrentMin),									% recursive call to reach the end of the players' list
	player(position(PlayerX, PlayerY), _, _, _),
	distance(Head, position(PlayerX, PlayerY), Distance),							% compute distance from me for the player 'Head' of the list
	min_from_location(																% finds the minimum distance between Distance and Min
		Distance, 																	% Distance from me of player 'Head'
		CurrentMin, 																% Distance from me goal of the current team mate closer to the goal 
		Min, 													
		Head, 																		% Head of the list of team mates
		Tar, 																		% Current team mate closer to me
		Target).	


% Used at the beginning of each half. The player assigned to start the game looks for the farthest team mate to pass him the ball
% max_distance_from_me(
%	PlayersList,																	% list of players
%	Target,																			% player who will be the target of the pass action
%	Min)																			% distance of the player 'Target' from the goal
max_distance_from_me([],_,1000).													% boundary case: empty list

max_distance_from_me([Head|Tail], Target, Min) :-									% general case: non-empty list of team mates
	max_distance_from_me(Tail, Tar, CurrentMin),									% recursive call to reach the end of the players' list
	goal_position(position(X, Y1), position(_,Y2)),									% get goal position
	GoalY is (Y1+Y2)/2,
	field(_, position(FieldWidth,_), _, _),											% get field width
	player(_,_,Team,_),																% get player's team
	% Get my own goal X coordinate
	(
		Team = team1,																% if my team is team1 then
		GoalX is X - (FieldWidth-1)													% my own goal is at position enemy_goal - field width
		;
		Team = team2,																% if my team is team1 then
		GoalX is X + (FieldWidth-1)													% my own goal is at position enemy_goal + field width
	),
	distance(Head, position(GoalX,GoalY), Distance),								% compute distance from my own goal for the player 'Head' of the list
	min_from_location(																% finds the minimum distance between Distance and Min
		Distance, 																	% Distance from the goal of player 'Head'
		CurrentMin, 																% Distance from the goal of the current team mate closer to the goal 
		Min, 													
		Head, 																		% Head of the list of team mates
		Tar, 																		% Current team mate closer to the goal
		Target).

% Do I see the ball?
% see_ball(
%	PlayerPosition,																	% player coordinates
%	BallPosition)																	% ball coordinates
see_ball(PlayerPosition, BallPosition) :- 											% I can see the ball if
	distance(PlayerPosition, BallPosition, Distance),								% the distance between me and the ball
	radius(Radius),																					
	Distance =< Radius.																% is <= than my influnce radius

% Do I see the goal?
% see_goal(
%	PlayerPosition,																	% player coordinates
%	GoalPosition)																	% goal coordinates
see_goal(PlayerPosition, GoalPosition) :-											% I see the goal if
	distance(PlayerPosition, GoalPosition, Distance),								% the distance between my position and the goal position
	radius(Radius),																	
	Distance =< Radius.																% is smaller than my radius 

% selects the closest cell (at distance 1 from the current player position) to the given target position
% next_cell(
%	CurrentX,																	% player current X coordinate
%	CurrentY,																	% player current Y coordinate
%	PosX,																		% target position X coordinate
%	PosY,																		% target position Y coordinate
%	Cell)																		% candidate cell number (see comments below to graphical aid)
next_cell(CurrentX, CurrentY, PosX, PosY, Cell) :- 
	PosX < CurrentX,															% 1 = = 
	PosY > CurrentY, !,															% = P = 	(Player)
	NewX is CurrentX - 1,														% = = = 	(Cell: X-1,Y+1)
	NewY is CurrentY + 1,														
 	Cell = position(NewX, NewY).

next_cell(CurrentX, CurrentY, PosX, PosY, Cell) :- 
	PosX == CurrentX,															% = 2 =														
	PosY > CurrentY, !,															% = P = 	(Player)
	NewY is CurrentY + 1,														% = = =		(Cell: X,Y+1)
	Cell = position(CurrentX, NewY).
 	
next_cell(CurrentX, CurrentY, PosX, PosY, Cell) :- 
	PosX > CurrentX,															% = = 3
	PosY > CurrentY, !,															% = P = 	(Player)
	NewX is CurrentX + 1,														% = = =		(Cell: X+1,Y+1)
	NewY is CurrentY + 1,
 	Cell = position(NewX, NewY).					

next_cell(CurrentX, CurrentY, PosX, PosY, Cell) :- 
	PosX < CurrentX,															% = = =	
	PosY == CurrentY, !,														% 4 P = 	(Player)
	NewX is CurrentX - 1,														% = = =		(Cell: X-1,Y)
 	Cell = position(NewX, CurrentY).

next_cell(CurrentX, CurrentY, PosX, PosY, Cell) :- 
	PosX > CurrentX,															% = = =	
	PosY == CurrentY, !,														% = P 5 	(Player)
	NewX is CurrentX + 1,														% = = =		(Cell: X+1,Y)
 	Cell = position(NewX, CurrentY).

next_cell(CurrentX, CurrentY, PosX, PosY, Cell) :- 
	PosX < CurrentX,															% = = =	
	PosY < CurrentY, !,															% = P = 	(Player)
	NewX is CurrentX - 1,														% 6 = =		(Cell: X-1,Y-1)
	(
		player(position(_,1),_,_,_), !,
		NewY is CurrentY
		;
		NewY is CurrentY - 1
	),
	Cell = position(NewX, NewY).

next_cell(CurrentX, CurrentY, PosX, PosY, Cell) :- 
	PosX == CurrentX,															% = = =	
	PosY < CurrentY, !,															% = P = 	(Player)
	NewY is CurrentY - 1,														% = 7 =		(Cell: X,Y-1)
 	Cell = position(CurrentX, NewY).

next_cell(CurrentX, CurrentY, PosX, PosY, Cell) :- 
	PosX > CurrentX,															% = = =	
	PosY < CurrentY, !,															% = P = 	(Player)
	NewX is CurrentX + 1,														% = = 8		(Cell: X+1,Y-1)
	(	
		player(position(_,1),_,_,_), !,	
		NewY is CurrentY 
		;
		NewY is CurrentY - 1
	),														
 	Cell = position(NewX, NewY).

% moves the player toward the target position by returning the closest cell to the target position
% move_to_pos(
%	PosX																		X coordinate of the target position
% 	PosY,																		Y coordinate of the target position
%	CellX,																		X coordinate of the cell in which the player will move
% 	CellY)																		Y coordinate of the cell in which the player will move
move_to_pos(PosX, PosY, CellX, CellY) :-
	(
		player(position(PosX, PosY), _, _, _), !,								% if my position is the target position I don't need to move
		player(position(CellX, CellY), _, _, _) 													
		;																		% or if my position is not the target position
		player(position(PlayerX, PlayerY), _, _, _),							% get Player position
		next_cell(PlayerX, PlayerY, PosX, PosY, NextCell),			   			% move in the closest cell (at distance 1) to the target position 
		NextCell =.. [_, CellX, CellY]														
	).

% Checks if the player is in the ball "safe zone" during an inactive_ball event. If he is inside the zone, he needs to move out of it
move_out(CellX, CellY) :-
	player(position(PlayerX, PlayerY), _, _, _),								% get player position
	ball(position(BallX, BallY),_),												% get ball position
	distance(position(PlayerX, PlayerY), position(BallX, BallY), Distance),		% compute distance player-ball
	ball_safe_zone(Radius),														% get ball "safe zone" width
	round(Distance) =< Radius,													% check if the distance player-ball is lower than the zone width
	(
		PlayerX >= BallX, !,													% if the player is to the right of the ball
		PosX is PlayerX + (Radius-Distance+1)									% sets the player's X coordinate just outside the zone
		;																		% or if the player is to the left of the ball
		PosX is PlayerX - (Radius-Distance+1)									% sets the player's X coordinate just outside the zone
	),
	move_to_pos(PosX, PlayerY, CellX, CellY).									% move to the new position outside the zone

% returns a random cell in which the player will move
% the cell is selected by checking a random number between 0-99. A cell will be selected if the random number falls in its "random number range"
% e.g. if the random number is in the range 12-22 then cell '1' will be selected. 
% next_random_cell(
% 	N,																			the random number											
%	PlayerX,																	player current X coordinate
%	PlayerY,																	player current Y coordinate
%	NewPos)																		the selected cell
next_random_cell(N, PlayerX, PlayerY, NewPos) :- 								% = = =
	N =< 11, !,																	% = P =		(Player)
	NewPos = position(PlayerX, PlayerY).										% = = =		(NewPos: same position)

next_random_cell(N, PlayerX, PlayerY, NewPos) :-  								% 1 = =
	N =< 22, !,																	% = P =		(Player)
	next_cell(PlayerX, PlayerY, -1, 53, NewPos).								% = = =		

next_random_cell(N, PlayerX, PlayerY, NewPos) :- 								% = 2 =
	N =< 33, !,																	% = P =		(Player)
	next_cell(PlayerX, PlayerY, PlayerX, 53, NewPos).							% = = =

next_random_cell(N, PlayerX, PlayerY, NewPos) :- 								% = = 3
	N =< 44, !,																	% = P =		(Player)
	next_cell(PlayerX, PlayerY, 53, 53, NewPos).								% = = =

next_random_cell(N, PlayerX, PlayerY, NewPos) :- 								% = = =
	N =< 55, !,																	% 4 P =		(Player)
	next_cell(PlayerX, PlayerY, -1, PlayerY, NewPos).							% = = =

next_random_cell(N, PlayerX, PlayerY, NewPos) :- 								% = = =
	N =< 66, !,																	% = P 5		(Player)
	next_cell(PlayerX, PlayerY, 53, PlayerY, NewPos).							% = = =

next_random_cell(N, PlayerX, PlayerY, NewPos) :- 								% = = =
	N =< 77, !,																	% = P =		(Player)
	next_cell(PlayerX, PlayerY, -1, -1, NewPos).								% 6 = =

next_random_cell(N, PlayerX, PlayerY, NewPos) :- 								% = = =
	N =< 88, !,																	% = P =		(Player)
	next_cell(PlayerX, PlayerY, PlayerX, -1, NewPos).							% = 7 =

next_random_cell(N, PlayerX, PlayerY, NewPos) :- 								% = = =
	N =< 99,																	% = P =		(Player)
	next_cell(PlayerX, PlayerY, 53, -1, NewPos).								% = = 8