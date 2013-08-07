with Ada.Calendar; use Ada.Calendar;
with Ada.Containers.Vectors; use Ada.Containers;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Soccer is

   -- Global stuff for the Soccer packages

   field_max_x : Positive := 30;
   field_max_y : Positive := 20;

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

   -- team one LEFT
   team_one_goal_starting_coord : Coordinate := Coordinate'(coord_x => 0,
							    coord_y => 9);
   -- team two RIGHT
   team_two_goal_starting_coord : Coordinate := Coordinate'(coord_x => 31,
							    coord_y => 9);

   goal_length : Positive := 2;

   -- penalty variables
   penalty_area_width : Positive := 6;
   penalty_area_height : Positive := 3;

   team_one_penalty_coord : Coordinate; -- TODO:: inizializza!
   team_two_penalty_coord : Coordinate; -- TODO:: inizializza!

   middle_field_coord : Coordinate; -- TODO:: inizializza!

   free_kick_area : Positive := 3;

   buffer_dim : Positive := 10;
   nearby_distance : Integer := 3;
   send_buffer_delay : Integer := 1;
   t0 : Time := Clock;

   number_of_zones : Integer := 4;

   type Power_Range is range 0 .. 10;

   --+ Utility di una mossa x/10
   subtype Utility_Range is Integer range 1 .. 10;
   subtype Utility_Constraint_Type is Utility_Range;

   utility_constraint : Utility_Constraint_Type := 2;

   num_of_players : Positive := 8;

   agent_movement_id : Integer := 0;

   type Positions_Array is array (1 .. num_of_players) of Coordinate;

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
