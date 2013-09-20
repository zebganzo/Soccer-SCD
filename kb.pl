/***************************************************************************************************************
 *												PLAYER STATUS FACTS											   *
 **************************************************************************************************************/

% game state term																  
:- dynamic(game/1).
game(running).																% state: running / ready / blocked / paused 

% event term. Used only with game status 'blocked'
%:- dynamic(event/1).
%event(init).																% type: init / end / inactive_ball			

% player influence "bubble" width
radius(8).

% player term
% player(
%	position(X,Y),															player position
%	BallPossession,															has / has_not. Player has/hasn't the ball
% 	Team																	team1 / team2. Player's team
%   LastHolder)																last_holder / not_last_holder
:- dynamic(position/2).
:- dynamic(player/3).
player(position(14, 16), has_not, team1, not_last_holder).

% ball(
%	position(X,Y), 															ball's position
% 	Team)  																	Team with ball possession
:- dynamic(ball/2).
ball(position(19, 17), team1).
																		 
% Nearby players term. Each nearby player is represented with a term
% nearby_player(
%	ID,																		player name 
% 	Position, 																position X,Y coordinates
%	HasBall, 																has / has_not
%	Team) 			
%:- dynamic(nearby_player/3). 												%team1 / team2
%nearby_player(position(15, 17), has_not, team1).

% Goal position 
% goal_position(
%	position(X,Y1)															lower point
%	position(X,Y2))															upper point
% goal_position(position(1,15), position(1,19)).							% team 2
goal_position(position(51,15), position(51,19)).							% team 1

% starting position
starting_position(13, 17).													% starting position X,Y coordinates

% defense position: the player's team is defending
defense_position(7, 17).													% defense position X,Y coordinates

% attack position: the player's team is attacking
attack_position(28, 9).													% attack position X,Y coordinates

% reference position: position assigned to the player during certain events.
%:- dynamic(reference_position/2).
%reference_position(35,12). 													% reference position X,Y coordinates.  */

% goal keeper
%role(keeper).

