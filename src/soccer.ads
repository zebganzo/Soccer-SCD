with Ada.Calendar; use Ada.Calendar;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Soccer is

   -- Global stuff for the Soccer packages

   field_max_x : Positive := 30;
   field_max_y : Positive := 20;

   -- Includo la coordinata 0,0 per simulare la panchina
   type Coordinate is
      record
         coordX   : Integer range 0 .. field_max_x + 1;
         coordY   : Integer range 0 .. field_max_y + 1;
      end record;
   type Coordinate_Ptr is access Coordinate;

   function Serialize_Coordinate (coord : in Coordinate) return Unbounded_String;

   function I2S (Num: in Integer) return String;

   -- team one up
   team_one_goal_starting_coord : Coordinate := Coordinate'(coordX => 9,
							    coordY => 0);
   -- team two down
   team_two_goal_starting_coord : Coordinate := Coordinate'(coordX => 9,
							    coordY => 31);

   goal_length : Positive := 2;

   -- penalty variables
   penalty_area_width : Positive := 6;
   penalty_area_height : Positive := 3;

   team_one_penalty_coord : Coordinate; -- TODO:: inizializza!
   team_two_penalty_coord : Coordinate; -- TODO:: inizializza!

   middle_field_coord : Coordinate; -- TODO:: inizializza!

   buffer_dim : Positive := 10;
   nearby_distance : Integer := 3;
   send_buffer_delay : Integer := 1;
   t0 : Time := Clock;

   type Power_Range is range 0 .. 10;

   --+ Utility di una mossa x/10
   subtype Utility_Range is Integer range 1 .. 10;
   subtype Utility_Constraint_Type is Utility_Range;

   utility_constraint : Utility_Constraint_Type := 2;
   num_of_players : Positive := 8;
   agent_movement_id : Integer := 0;

   type Formation_Scheme is (O_352, B_442, D_532);

end Soccer;
