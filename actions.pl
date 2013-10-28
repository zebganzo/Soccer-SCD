/***************************************************************************************************************
 *											GAME BLOCKED MOVEMENTS											   *
 **************************************************************************************************************/

% Catch action if the game is in status 'blocked', caused by an 'inactive_ball' event (free kick, penalty, corner ...)
% If the player is the one assigned to resume the game and he is in his reference position, he catches the ball.
% action(
%	CellX,																		X coordinate of the cell in which the player will move
%	CellY																		Y coordinate of the cell in which the player will move
%	Move) 																		'catch'
% current_predicate(:PredicateIndicator) is a predefined procedure that is True if PredicateIndicator is a currently defined predicate
action(CellX, CellY, catch) :-
	game(blocked),																% game status: 'blocked'
	current_predicate(reference_position/2),									% if I'm the one assigned to resume the game 
	player(position(PlayerX, PlayerY), has_not, _, _),
	reference_position(PlayerX, PlayerY), !,									% check if I'm in my assigned position
	reference_position(CellX, CellY).

% Move action at the very start of the game. The player goes from his "bench" position to the field entrance.
% action(
% CellX,																		X coordinate of the cell in which the player will move
% CellY,																		Y coordinate of the cell in which the player will move
% Move)																			'move'
action(CellX, CellY, move) :-
	game(blocked),																% game status: 'blocked'
	event(init),																% event: 'init'
	\+(player(position(26,0),_,_,_)),											% if the player is not in the field entrance 
	(player(position(_,0),_,_,_)), !,											% but he is in his bench position
	CellX = 26,																	% move to the field entrance
	CellY = 0.

% Move action if the game is in status 'blocked', caused by an 'init' event (start of the match, start of the second half of the match) or 
% a 'goal' event (a goal has been scored).
% Player must move to his starting position. The player moves one cell at a time
% movement(
%	CellX,																		X coordinate of the cell in which the player will move
%	CellY																		Y coordinate of the cell in which the player will move
%	Move) 																		'move'
% current_predicate(:PredicateIndicator) is a predefined procedure that is True if PredicateIndicator is a currently defined predicate
action(CellX, CellY, move) :-
	game(blocked), 																% game status: 'blocked'
	(
		event(init), !															% event: 'init'
		;
		event(goal), !															% event: 'goal'
	),	
	(
		current_predicate(reference_position/2), !,								% checks if the player has a fixed assigned position
		reference_position(RefX, RefY),											% get the player assigned position
		move_to_pos(RefX, RefY, CellX, CellY)									% move to the closest cell to the  fixed assigned position
		;
		starting_position(StartX, StartY),										% get starting position
		move_to_pos(StartX, StartY, CellX, CellY)								% move to the closest cell to the starting position
	).

% Move action if the game is in status 'blocked', caused by a 'goal_kick' event. The player moves one cell at a time
% A normal player is never assigned to resume the game in this event type, therefore we just retrieve his goal kick position and 
% move him there
% action(
%	CellX,																		X coordinate of the cell in which the player will move
%	CellY,																		Y coordinate of the cell in which the player will move
%	Move) 																		'move'
action(CellX, CellY, move) :-
	game(blocked),																% game status: 'blocked'
	event(goal_kick), !,														% event: 'goal_kick'
	goal_kick_position(GKickX, GKickY),											% retrieve goal_kick_position
	move_to_pos(GKickX, GKickY, CellX, CellY).									% move to the goal_kick_position

% Move action if the game is in status 'blocked', caused by a 'corner_kick' event.
% If the player is the one assigned to resume the game he moves towards his reference position.
% Otherwise the player must move to his corner kick position. The player moves one cell at a time
% action(
%	CellX,																		X coordinate of the cell in which the player will move
%	CellY,																		Y coordinate of the cell in which the player will move
%	Move) 																		'move'
% current_predicate(:PredicateIndicator) is a predefined procedure that is True if PredicateIndicator is a currently defined predicate
action(CellX, CellY, move) :-
	game(blocked),																% game status: 'blocked'
	event(corner_kick), !,														% game event: 'corner_kick'
	(
		current_predicate(reference_position/2), !,								% checks if the player has a fixed assigned position
		reference_position(RefX, RefY),											% get the player assigned position
		move_to_pos(RefX, RefY, CellX, CellY)									% move to the closest cell to the  fixed assigned position
		;																		% or if the player has not a fixed position
		corner_kick_position(CornerX, CornerY),									% retrieve corner_kick_position
		move_to_pos(CornerX, CornerY, CellX, CellY)								% move to the corner_kick_position
	).

% Move action if the game is in status 'blocked', caused by a 'penalty_kick' event.
% If the player is the one assigned to resume the game he moves towards his reference position.
% Otherwise the player must move to his corner kick position. The player moves one cell at a time
% action(
%	CellX,																		X coordinate of the cell in which the player will move
%	CellY,																		Y coordinate of the cell in which the player will move
%	Move) 																		'move'
% current_predicate(:PredicateIndicator) is a predefined procedure that is True if PredicateIndicator is a currently defined predicate
action(CellX, CellY, move) :-
	game(blocked),																% game status: 'blocked'
	event(penalty_kick), !, 													% game event: 'penalty_kick'
	(
		current_predicate(reference_position/2), !,								% checks if the player has a fixed assigned position
		reference_position(RefX, RefY),											% get the player assigned position
		move_to_pos(RefX, RefY, CellX, CellY)									% move to the closest cell to the  fixed assigned position
		;																		% or if the player has not a fixed position
		penalty_kick_position(PenaltyX, PenaltyY),								% retrieve penalty_kick_position
		move_to_pos(PenaltyX, PenaltyY, CellX, CellY)							% move to the penalty_kick_position
	).

% Move action if the game is in status 'blocked', caused by a 'free_kick' or a throw_in event.
% If the player is the one assigned to resume the game he moves towards his reference position.
% Otherwise the player must move out of the "safe zone" the ball is in. The player moves one cell at a time
% action(
%	CellX,																		X coordinate of the cell in which the player will move
%	CellY,																		Y coordinate of the cell in which the player will move
%	Move) 																		'move'
% current_predicate(:PredicateIndicator) is a predefined procedure that is True if PredicateIndicator is a currently defined predicate
action(CellX, CellY, move) :-
	game(blocked), 																% game status: 'blocked'
		(
		event(throw_in), !															% event: 'throw_in'
		;
		event(free_kick), !															% event: 'free_kick'
	),	
	(
		current_predicate(reference_position/2), !,								% checks if the player has a fixed assigned position
		reference_position(RefX, RefY),											% get the player assigned position
		move_to_pos(RefX, RefY, CellX, CellY)									% move to the closest cell to the  fixed assigned position
		;																		% or if the player has not a fixed position
		move_out(CellX, CellY), !												% check if he is inside the ball "safe zone" and move him out of it
		;																		% or if the player has not a fixed assigned position and he is not in																										
		player(position(CellX, CellY), _, _, _)									% the safe zone, he doesn't need to move
	).

% Shot action at the end of a game. The player drops the ball before moving towards the exit
% action(
%	CellX,																		X coordinate of the cell in which the player will move
%	CellY																		Y coordinate of the cell in which the player will move
%	Move) 																		'shot'
action(CellX, CellY, shot) :-
	game(blocked),																% game status: 'blocked'
	event(end), 																% event: 'end'
	player(position(CellX, CellY), has, _, _), !.

% Move action if the game is in status 'blocked', caused by an 'end' event (end of the first half, end of the match)
% Player must move to the lower left corner of the field. The player moves one cell at a time
% action(
%	CellX,																		X coordinate of the cell in which the player will move
%	CellY																		Y coordinate of the cell in which the player will move
%	Move) 																		'move'
action(CellX, CellY, move) :-
	game(blocked), 																% game status: 'blocked'
	event(end), !,																% event: 'end'
	(
		player(position(26,0), _, _, _), !,
		CellX = 1000,
		CellY = 0
		; 
		move_to_pos(26, 0, CellX, CellY)
	).

/***************************************************************************************************************
 *											GAME READY MOVEMENTS											   *
 **************************************************************************************************************/

% Pass action : this version is used at the beginning of each half (init event). 
% The player assigned to start the game looks for the farthest team mate to pass him the ball
% action(
%	TargetX,																	X coordinate of the destination of my pass 
%	TargetY																		Y coordinate of the destination of my pass 
%	Move)																		'pass'
action(TargetX, TargetY, pass) :-
	game(ready),																% game status: 'ready'
	player(_, has, Team, _),													% if the player has the ball
	(
		event(init), !															% event: 'init'
		;
		event(goal), !															% event: 'goal'
	),	
	% finds the target of the pass action
	current_predicate(nearby_player/3),
	bagof(Position, nearby_player(Position, _,Team), TargetList),				% find all nearby team mates 
 	max_distance_from_me(TargetList, TargetCell, _),							% return the closest to the goal
	TargetCell =.. [_, TargetX, TargetY], !.

% Shot action for a penalty kick. 
% The player assigned to start the game shots
% action(
%	TargetX,																	X coordinate of the destination of my pass 
%	TargetY																		Y coordinate of the destination of my pass 
%	Move)																		'shot'
action(TargetX, TargetY, shot) :-
	game(ready),																% game status: 'ready'
	player(_, has, Team, _),													% if the player has the ball
	event(penalty_kick), !,														% event: 'penalty_kick'
	goal_position(position(GoalX, _), _),										% get goal X coordinate
	(
		Team = team1,
		ShotX is GoalX + 1
		;
		Team = team2,
		ShotX is GoalX - 1
	),
	% shot coordinates
	TargetX is ShotX,															% set shot X coordinate
	shotY(TargetY).																% set shot Y coordinate

% Shot action for a free kick. 
% The player assigned to start the game takes a shot if he sees the goal
% action(
%	TargetX,																	X coordinate of the destination of my pass 
%	TargetY																		Y coordinate of the destination of my pass 
%	Move)																		'shot'
action(TargetX, TargetY, shot) :-
	game(ready),																% game status: 'ready'
	player(position(PlayerX, PlayerY), has, Team, _),							% if the player has the ball
	event(free_kick), 															% event: 'free_kick'
	% checks if the player sees the goal
	goal_position(position(GoalX, Y1), position(_,Y2)),							% get goal position
	GoalY is (Y1+Y2)/2,
	see_goal(position(PlayerX, PlayerY), position(GoalX, GoalY)), !,			% does the player see the goal? if not the Shot action must fail
	(
		Team = team1, !,
		ShotX is GoalX + 1
		;
		Team = team2,
		ShotX is GoalX - 1
	),
	% shot coordinates
	TargetX is ShotX,	
	% shot coordinates
	shotY(TargetY).																% set shot Y coordinate

% Pass action for free kick, corner kick and throw-in events. 
% The player assigned to start the game passes the ball to the closest team mate
% action(
%	TargetX,																	X coordinate of the destination of my pass 
%	TargetY																		Y coordinate of the destination of my pass 
%	Move)																		'pass'
action(TargetX, TargetY, pass) :-
	game(ready),																% game status: 'ready'
	player(position(PlayerX, PlayerY), has, Team, _),													% if the player has the ball
	(
		event(free_kick), !														% event: 'free_kick'
		;
		event(corner_kick), !													% event: 'corner_kick'
		;	
		event(throw_in), !														% event: 'throw_in'
	),
	% finds the target of the pass action
	current_predicate(nearby_player/3),
	bagof(Position, nearby_player(Position, _,Team), TargetList),				% find all nearby team mates 
 %	min_distance_from_me(TargetList, TargetCell, _),							% return the closest to the goal
 	min_distance_from(TargetList, TargetCell, _, position(PlayerX, PlayerY)),
	TargetCell =.. [_, TargetX, TargetY], !.

% Move action for game status 'Ready' if the player is not the one assigned to resume the game.
% The player does not move
% action(
%	TargetX,																	X coordinate of the destination of my pass 
%	TargetY																		Y coordinate of the destination of my pass 
%	Move)
action(CellX, CellY, move) :-
	game(ready),!,
	player(position(CellX, CellY), _, _, _).

/***************************************************************************************************************
 *										GAME RUNNING	PLAYER WITH BALL RULES								   *
 **************************************************************************************************************/

% Pass action : Player must have the ball / Player must have a team mate within his range
% action(
%	TargetX,																	X coordinate of the destination of my pass 
%	TargetY																		Y coordinate of the destination of my pass 
%	Move)																		'pass'															
action(TargetX, TargetY, pass) :- 
	game(running),
	player(position(PlayerX, PlayerY), has, Team, _),							% and if the player has the ball
	% finds the target of the pass action
	current_predicate(nearby_player/3),
	bagof(Position, nearby_player(Position, _,Team), TargetList),				% find all nearby team mates 
	add(position(PlayerX, PlayerY), TargetList, List),							% add the player itself to the list to check if he is the most advanced 
																				% in the field
% 	min_distance_from_goal(List, TargetCell, _),								% return the closest to the goal
	goal_position(position(GoalX, Y1), position(_,Y2)),								% get goal position
	GoalY is (Y1+Y2)/2,
	min_distance_from(List, TargetCell, _, position(GoalX, GoalY)),
	TargetCell =.. [_, TargetX, TargetY],
	\+(player(position(TargetX, TargetY), _, _, _)), !.

% Shot action : Player must have the ball / Player must see the goal
% action(
%	TargetX,																	X coordinate of the destination of my shot 
%	TargetY																		Y coordinate of the destination of my shot
%	Move)																		'shot'				
action(TargetX, TargetY, shot) :-		
	game(running),																% a Shot action can be made if the game is in status 'running'
	player(position(PlayerX, PlayerY), has, Team, _),							% and if the player has the ball
	% checks if the player sees the goal
	goal_position(position(GoalX, Y1), position(_,Y2)),							% get goal position
	GoalY is (Y1+Y2)/2,
	see_goal(position(PlayerX, PlayerY), position(GoalX, GoalY)), !,			% does the player see the goal? if not the Shot action must fail
	(
		Team = team1,
		ShotX is GoalX + 1
		;
		Team = team2,
		ShotX is GoalX - 1
	),
	% shot coordinates
	TargetX is ShotX,	
	shotY(TargetY).


% Move action if the game status is 'running', the player has the ball. Player moves towards the attack position. 
% If he is already in the attack position then he moves towards the goal. The player moves one cell at a time
% action(
%	CellX,																		X coordinate of the cell in which the player will move
% 	CellY																		Y coordinate of the cell in which the player will move
%	Move)																		'move'
action(CellX, CellY, move) :-
	game(running),																% game status: 'running'
	player(position(PlayerX, PlayerY), has, Team, _), !,						% check if the player has the ball
	attack_position(AttX, AttY),  												% check if the player is in its attack position
	(
		PlayerX >= AttX, Team = team1, !,										% if the player is at/past the assigned attack position (team1)
		goal_position(position(GoalX, Y1), position(_,Y2)),						% get goal position
		GoalY is (Y1+Y2)/2,															
		next_cell(PlayerX, PlayerY, GoalX, GoalY, Cell),						% and move him closer to the goal
		Cell =.. [_, CellX, CellY]
		;
		PlayerX < AttX, Team = team1, !,										% if the player is before the attack position (team1)
		move_to_pos(AttX, AttY, CellX, CellY)									% move him to the closest cell to the attack position
		;
		PlayerX > AttX, Team = team2, !,										% if the player is before the attack position (team2)
		move_to_pos(AttX, AttY, CellX, CellY)									% move him to the closest cell to the attack position
		;
		PlayerX =< AttX, Team = team2,											% if the player is at/past the assigned attack position (team2)
		goal_position(position(GoalX, Y1), position(_,Y2)),						% get goal position
		GoalY is (Y1+Y2)/2,															
		next_cell(PlayerX, PlayerY, GoalX, GoalY, Cell),						% and move him closer to the goal
		Cell =.. [_, CellX, CellY]
	).

/***************************************************************************************************************
 *										GAME RUNNING	PLAYER WITHOUT BALL RULES							   *
 **************************************************************************************************************/
/***************************************************************************************************************
 *										GAME RUNNING	TACKLE / CATCH RULES								   *
 **************************************************************************************************************/

% Tackle action : Player do not have the ball / Player sees an enemy player with the ball at distance 1
% action(
% 	CellX,																			X coordinate of the player with the ball I want to steal
% 	CellY																			Y coordinate of the player with the ball I want to steal
%	Move) 																			'steal'
action(CellX, CellY, tackle) :-	
	game(running),																	% game status 'running'
	player(position(PlayerX,PlayerY), has_not, Team, not_last_holder),
	current_predicate(nearby_player/3),
	bagof(NearbyTeam, nearby_player(_, has, NearbyTeam), TargetTeam), 				% a player with the ball is near? get his team
	bagof(Position, nearby_player(Position, has, _), TargetPosition),				% and his position
	\+([Team|_] = TargetTeam),														% if the nearby player with the ball is not a team mate
	[Pos|_] = TargetPosition,	
	distance(position(PlayerX, PlayerY), Pos, Distance),							% the 'tackle' action can be performed only with 
	round(Distance) =:= 1, !,														% targets at distance 1 
	Pos =.. [_, CellX, CellY].

% Catch action : Player do not have the ball / The ball is at distance = 1 / The ball is free
% action(
% 	CellX,																			X coordinate of the ball
% 	CellY																			Y coordinate of the ball
%	Move) 																			'catch'
action(CellX, CellY, catch) :-
	game(running),																	% game status: 'running'
	player(position(PlayerX,PlayerY), has_not, _, not_last_holder),
	ball(position(BallX,BallY),_),													% get ball position
	see_ball(position(PlayerX, PlayerY), position(BallX, BallY)),					% Do I see the ball?
	distance(position(PlayerX, PlayerY), position(BallX, BallY), Distance),			% the 'catch' action can be performed only with
	round(Distance) =< 1,															% the ball at distance 1 
	(
		current_predicate(nearby_player/3),
		\+(bagof(_, nearby_player(_, has, _), _)), !,								% the ball is currently free (nobody near me has it) 
		ball(position(CellX, CellY), _)
		;
		\+(current_predicate(nearby_player/3)),
		ball(position(CellX, CellY), _)
	).

% Move action if the game status is 'running'.
% Player checks if there is another player near him with the ball. If such a player exist and he is a member of the opposing team,
% the player moves towards him to perform a Tackle action. The player moves one cell at a time
% action(
%	CellX,																			X coordinate of the cell in which the player will move
% 	CellY																			Y coordinate of the cell in which the player will move
%	Move)																			'move'
action(CellX, CellY, move) :-
	game(running),																	% game status: 'running'
	player(_, has_not, Team, not_last_holder),										% get my team
	current_predicate(nearby_player/3),
	bagof(NearbyTeam, nearby_player(_, has, NearbyTeam), TargetTeam),				% a player with the ball is near? get his team
	bagof(Position, nearby_player(Position, has, _), TargetPosition),				% and his position
	\+([Team|_] = TargetTeam), !,													% if the nearby player with the ball is not a team mate
	[Pos|_] = TargetPosition,														% get his position																											
	Pos =.. [_, PosX, PosY],														% and
	move_to_pos(PosX, PosY, CellX, CellY).

% Move action if the game status is 'running'. The player checks if the ball is "free" (nobody is holding it) and near him. 
% If so he moves towards the ball to perform a Catch action. The player moves one cell at a time.
% action(
%	CellX,																			X coordinate of the cell in which the player will move
% 	CellY																			Y coordinate of the cell in which the player will move
%	Move)																			'move'
action(CellX, CellY, move) :-
	game(running),																	% game status: 'running'
	player(position(PlayerX, PlayerY), has_not, _, not_last_holder),
	ball(position(BallX,BallY),_),
	see_ball(position(PlayerX, PlayerY), position(BallX, BallY)), 					% Do I see the ball?
	(
%		current_predicate(nearby_player/3),
%		\+(bagof(_, nearby_player(_, has, _), _)), !,								% the ball is currently free (nobody near me has it) 
%		move_to_pos(BallX, BallY, CellX, CellY)
		current_predicate(nearby_player/3),
		bagof(Position, Team^nearby_player(Position, _, Team), TargetPosition),
		add(position(PlayerX, PlayerY), TargetPosition, List),
		min_distance_from(List, TargetCell, _, position(BallX,BallY)),
		TargetCell =.. [_, TargetX, TargetY],
		player(position(TargetX, TargetY), _, _, _),
		move_to_pos(BallX, BallY, CellX, CellY)
		;
		\+(current_predicate(nearby_player/3)),
		move_to_pos(BallX, BallY, CellX, CellY)
	).

/***************************************************************************************************************
 *										GAME RUNNING	GENERIC MOVEMENTS									   *
 **************************************************************************************************************/
% Move action if the game status is 'running', the player's team is in a defense phase (ball possession lost)
% Player must move to his defense position. The player moves one cell at a time
% action(
%	CellX,																		X coordinate of the cell in which the player will move
% 	CellY																		Y coordinate of the cell in which the player will move
%	Move)																		'move'
action(CellX, CellY, move) :-
	game(running),																% game status: 'running'
	player(position(PlayerX, PlayerY), has_not, Team, _),
	\+(ball(_, Team)), !,														% true if the player's team has not the ball
	(
		defense_position(PlayerX, PlayerY),	!,									% if the player is already in his defense position
		N is random(100),														% he moves randomly in one of the surrounding cells
		next_random_cell(N, PlayerX, PlayerY, NewPos),
		NewPos =.. [_, CellX, CellY], !
		;																		% or if the player is not in his defense position yet
		defense_position(DefX, DefY),											% get player defense position
	    move_to_pos(DefX, DefY, CellX, CellY)									% move him to the closest cell to the defense position
	).

% Move action if the game status is 'running', the player has not the ball but the player's team is in an attack phase (ball possession) 
% Player must move to his attack position. The player moves one cell at a time
% action(
%	CellX,																		X coordinate of the cell in which the player will move
% 	CellY																		Y coordinate of the cell in which the player will move
%	Move)																		'move'
action(CellX, CellY, move) :-
	game(running),																% game status: 'running'
	player(position(PlayerX, PlayerY), has_not, _, _),
	(
		attack_position(PlayerX, PlayerY), !,									% if the player is already in his attack position
		N is random(100),														% he moves randomly in one of the surrounding cells
		next_random_cell(N, PlayerX, PlayerY, NewPos),
		NewPos =.. [_, CellX, CellY], !
		;																		% or if the player is not in his attack position yet
		attack_position(AttX, AttY),											% get player attack position
	    move_to_pos(AttX, AttY, CellX, CellY)									% move him to the closest cell to the attack position
	).