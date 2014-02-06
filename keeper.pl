/***************************************************************************************************************
 *											GAME BLOCKED MOVEMENTS											   *
 **************************************************************************************************************/
 
 action(CellX, CellY, move) :-
	game(blocked),
	current_predicate(substitution/1), 
	substitution(out), !,
	(
		player(position(26,0), _, _, _), !,
		CellX = 1000,
		CellY = 0
		; 
		move_to_pos(26, 0, CellX, CellY)
	).


action(CellX, CellY, move) :-
	game(blocked),
	current_predicate(substitution/1), 
	substitution(in),
	(
		\+(player(position(26,0),_,_,_)),										% if the player is not in the field entrance 
		(player(position(_,0),_,_,_)), !,										% but he is in his bench position
		CellX = 26,																% move to the field entrance
		CellY = 0
	).

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

% Move action if the game is in status 'blocked', caused by a 'goal_kick' event.
% If the player is the one assigned to resume the game he moves towards his reference position.
% Otherwise the player doesn't need to move. The player moves one cell at a time.
% movement(
%	CellX,																		X coordinate of the cell in which the player will move
%	CellY																		Y coordinate of the cell in which the player will move
%	Move) 																		'move'
% current_predicate(:PredicateIndicator) is a predefined procedure that is True if PredicateIndicator is a currently defined predicate
action(CellX, CellY, move) :-
	game(blocked),
	event(goal_kick), !,
	(
		current_predicate(reference_position/2), !,								% checks if the player has a fixed assigned position
		reference_position(RefX, RefY),											% get the player assigned position
		move_to_pos(RefX, RefY, CellX, CellY)									% move to the closest cell to the  fixed assigned position
		;
		goal_kick_position(GKickX, GKickY),
		move_to_pos(GKickX, GKickY, CellX, CellY)
	).

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

% Move action if the game is in status 'blocked', caused by an event (free kick, penalty, corner ...)
% If the player is the one assigned to resume the game he moves towards his reference position.
% Otherwise the player must move out of the "safe zone" the ball is in. The player moves one cell at a time
% action(
%	CellX,																		X coordinate of the cell in which the player will move
%	CellY																		Y coordinate of the cell in which the player will move
%	Move) 																		'move'
% current_predicate(:PredicateIndicator) is a predefined procedure that is True if PredicateIndicator is a currently defined predicate
action(CellX, CellY, move) :-
	game(blocked), 																% game status: 'blocked'
	(
		event(free_kick), !														% event: 'free_kick'
		;
		event(throw_in), !														% event: 'throw_in'
	),
	(
		current_predicate(reference_position/2), !,								% checks if the player has a fixed assigned position
		reference_position(RefX, RefY),											% get the player assigned position
		move_to_pos(RefX, RefY, CellX, CellY)									% move to the closest cell to the  fixed assigned position
		;																		% or if the player has not a fixed assigned position 
		player(position(26,0),_,_,_), !,
		CellX = 26,
		CellY = 1
		;																										
		player(position(CellX, CellY), _, _, _)									% he doesn't need to move
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
% Pass action for free kick, corner kick and throw-in events. 
% The player assigned to start the game passes the ball to the closest team mate
% action(
%	TargetX,																	X coordinate of the destination of my pass 
%	TargetY																		Y coordinate of the destination of my pass 
%	Move)																		'pass'
action(TargetX, TargetY, pass) :-
	game(ready),																% game status: 'ready'
	player(_, has, Team, _),													% if the player has the ball
	event(goal_kick), !,														% event: 'goal_kick'
	% finds the target of the pass action
	current_predicate(nearby_player/3),
	bagof(Position, nearby_player(Position, _,Team), TargetList),				% find all nearby team mates 
 	min_distance_from_me(TargetList, TargetCell, _),							% return the closest to the goal
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
 	min_distance_from_goal(List, TargetCell, _),								% return the closest to the goal
	TargetCell =.. [_, TargetX, TargetY],
	\+(player(position(TargetX, TargetY), _, _, _)), !.

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
 *										GAME RUNNING	CATCH RULES											   *
 **************************************************************************************************************/

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
		current_predicate(nearby_player/3),
		bagof(Position, Team^nearby_player(Position, _, Team), TargetPosition),
		add(position(PlayerX, PlayerY), TargetPosition, List),
		min_distance_from(List, TargetCell, _, position(BallX,BallY)),
		TargetCell =.. [_, TargetX, TargetY],
		player(position(TargetX, TargetY), _, _, _), !,
		move_to_pos(BallX, BallY, CellX, CellY)
		;
		\+(current_predicate(nearby_player/3)), !,
		move_to_pos(BallX, BallY, CellX, CellY)
	).

/***************************************************************************************************************
 *												PLAYER GENERIC MOVEMENTS									   *
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
		defense_position(CellX, CellY)
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
		attack_position(CellX, CellY)
		;																		% or if the player is not in his attack position yet
		attack_position(AttX, AttY),											% get player attack position
	    move_to_pos(AttX, AttY, CellX, CellY)									% move him to the closest cell to the attack position
	).