with Ada.Calendar; use Ada.Calendar;
with Ada.Containers.Vectors; use Ada.Containers;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Soccer is

   -- Global stuff for the Soccer packages

   field_max_x : Positive := 51;
   field_max_y : Positive := 33;

   -- Includo la coordinata 0,0 per simulare la panchina
   type Coordinate is
      record
         coord_x   : Integer range 0 .. field_max_x + 1;
         coord_y   : Integer range 0 .. field_max_y + 1;
      end record;
   type Coordinate_Ptr is access Coordinate;

   procedure Set_Coord_X (coord : in out Coordinate; value : in Integer);
   procedure Set_Coord_Y (coord : in out Coordinate; value : in Integer);

   function Serialize_Coordinate (coord : in Coordinate) return Unbounded_String;

   function I2S (Num: in Integer) return String;

   half_game_duration : Positive := 180;

   team_one_score : Integer := 0;
   team_two_score : Integer := 0;

   -- team one [LEFT]
   team_one_goal_lower_coord : Coordinate := Coordinate'(0,15);
   team_one_goal_upper_coord : Coordinate := Coordinate'(0,19);

   team_one_goalkeeper_coord : Coordinate := Coordinate'(1,17);

   team_one_penalty_lower_left_coord : Coordinate := Coordinate'(1,9);
   team_one_penalty_upper_left_coord : Coordinate := Coordinate'(1,25);
   team_one_penalty_lower_right_coord : Coordinate := Coordinate'(8,9);
   team_one_penalty_upper_right_coord : Coordinate := Coordinate'(8,25);

   team_one_penalty_coord : Coordinate := Coordinate'(6,17);

   -- team two [RIGHT]
   team_two_goal_lower_coord : Coordinate := Coordinate'(field_max_x + 1,15);
   team_two_goal_upper_coord : Coordinate := Coordinate'(field_max_x + 1,19);

   team_two_goalkeeper_coord : Coordinate := Coordinate'(51,17);

   team_two_penalty_lower_left_coord : Coordinate := Coordinate'(44,9);
   team_two_penalty_upper_left_coord : Coordinate := Coordinate'(44,25);
   team_two_penalty_lower_right_coord : Coordinate := Coordinate'(51,9);
   team_two_penalty_upper_right_coord : Coordinate := Coordinate'(51,25);

   team_two_penalty_coord : Coordinate := Coordinate'(46,17);

   middle_field_coord : Coordinate := Coordinate'(26,17);

   free_kick_area : Positive := 4;

   lower_left_corner : Coordinate := Coordinate'(1,1);
   lower_righr_corner : Coordinate := Coordinate'(51,1);
   upper_left_corner : Coordinate := Coordinate'(1,33);
   upper_right_corner : Coordinate := Coordinate'(51,33);

   -- oblivium
   oblivium : Coordinate := Coordinate'((field_max_x/2)+1,0);

   buffer_dim : Positive := 30;
   nearby_distance : Integer := 3;
   send_buffer_delay : Integer := 250;
   t0 : Time := Clock;

   number_of_zones : Integer := 7;

   ball_speed : Float := 0.2;
   players_delay : Float := 0.2;
   print_delay : Float := 0.5;

   hyperperiod_length : Duration;

   type Power_Range is range 1 .. 10;

   --+ Utility di una mossa x/10
   subtype Utility_Range is Integer range 1 .. 10;
   subtype Utility_Constraint_Type is Utility_Range;

   utility_constraint : Utility_Constraint_Type := 2;

   -- players
   num_of_players     : Positive := 22;
   total_players      : Positive := 36;
   backup_players     : Positive := (total_players/2)-(num_of_players/2);
   players_stats      : constant Positive := 7;
   attack_index	      : constant Positive := 1;
   defense_index      : constant Positive := 2;
   power_index	      : constant Positive := 3;
   precision_index    : constant Positive := 4;
   speed_index	      : constant Positive := 5;
   tackle_index	      : constant Positive := 6;
   goal_keeping_index : constant Positive := 7;

   agent_movement_id : Integer := 0;

   type Positions_Array is array (1 .. 11) of Coordinate;

   type Game_State is (Game_Running,
		       Game_Ready,
		       Game_Blocked,
		       Game_Paused);

   type Formation_Scheme_Id is (O_352, B_442, D_532);
   type Formation_Scheme is
      record
	 id : Formation_Scheme_Id;
	 positions : Positions_Array;
      end record;


end Soccer;
