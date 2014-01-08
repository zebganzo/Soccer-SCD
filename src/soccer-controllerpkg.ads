with Ada.Containers.Vectors; use Ada.Containers;
with Soccer.Core_Event.Motion_Core_Event; use Soccer.Core_Event.Motion_Core_Event;

with Soccer.Manager_Event.Substitution; use Soccer.Manager_Event.Substitution;

with Soccer.TeamPkg; use Soccer.TeamPkg;
with Soccer.Core_Event.Game_Core_Event; use Soccer.Core_Event.Game_Core_Event;

package Soccer.ControllerPkg is

   -- New Types

   --+-------------
   debug : Boolean := False;
   --+-------------

   type Action is
      record
         event : Motion_Event_Ptr;
         utility : Utility_Range;
      end record;

   type Player_Status is
      record
	 id : Integer;
	 number : Integer;
         team : Team_Id;
         running : Boolean := False;
         on_the_field : Boolean := False;
	 coord : Coordinate; -- := Coordinate'(coord_x => 0, coord_y => 0); -- FIXME:: se ci sono problemi, rimettilo!
	 reference_coord : Coordinate;
	 distance : Integer;
      end record;

   type Status is array (1 .. total_players) of Player_Status;

   package Players_Container is new Vectors (Index_Type   => Natural,
                                             Element_Type => Player_Status);
   type Read_Result_Type is
      record
         players_in_my_zone : Players_Container.Vector;
         holder_id : Integer;
      end record;
   type Read_Result is access Read_Result_Type;

   type Generic_Status is
      record
	 coord : Coordinate;
	 number : Integer;
	 team : Team_Id;
         holder : Boolean;	-- ho la palla o no
	 nearby : Boolean;      -- palla vicina o no
	 last_game_event : Game_Event_Ptr;
	 game_status : Game_State;
         substitutions : Substitutions_Container.Vector;
         holder_team : Team_Id;
	 last_ball_holder_id : Integer;
	 must_exit : Boolean;
	 last_checkpoint : Time;
      end record;
   type Generic_Status_Ptr is access Generic_Status;

   -- Functions, Procedure, ecc...

   function Get_Generic_Status (id : in Integer) return Generic_Status_Ptr;

   procedure Set_Last_Game_Event (event : Game_Event_Ptr);

   function Get_Last_Game_Event return Game_Event_Ptr;

   procedure Reset_Game;

   function Is_Cell_Free (coord : Coordinate) return Boolean;

--     procedure Set_Paused;

--     procedure Is_Paused (pause : out Boolean);

--     function Evaluate_Pause return Boolean;

--     procedure Notify;

   procedure Set_Must_Exit;

   function Get_Alternative_Coord (coord : Coordinate; target : Coordinate) return Coordinate;

   function Get_Game_Status return Game_State;

   procedure Get_Id (id : out Integer);

   procedure Set_Game_Status (new_status : Game_State);

   function Get_Players_Status return Status;

   function Is_On_The_Field (id : Integer) return Boolean;

   function Get_Player_Position (id : Integer) return Coordinate;

   function Read_Status (x : in Integer; y : in Integer; r : in Integer) return Read_Result;

   -- Returns the player's team, given the player's id
   function Get_Player_Team_From_Id(id : in Integer) return Team_Id;

   -- Returns the player's id, given his number and his team
   function Get_Id_From_Number(number : in Integer; team : Team_Id) return Integer;

   -- Returns the player number from id
   function Get_Number_From_Id (id : in Integer) return Integer;

   procedure Set_Checkpoint_Time;

   procedure Refresh_Hyperperiod;

--     task Field_Printer;

   procedure Print_Status;

   procedure Print_Zones;

   type Field_Zones is new Integer range 0 .. number_of_zones; -- anche la zona fuori dal campo!
   type Released_Zones is array (0 .. number_of_zones) of Boolean;

   task Controller is
      entry Get_Id (id : out Integer);
      entry Write (current_action : in out Action);
      entry Notify;
      entry Must_Exit;
   end Controller;

   protected Guard is
      entry Update (zone : Field_Zones; occupy : Boolean);
      entry Wait (Field_Zones) (current_action : in out Action);

   private
      released : Released_Zones;
   end Guard;

private
   must_exit : Boolean;
   exit_count : Integer;
   last_player_event : Motion_Event_Ptr;
   last_game_event : Game_Event_Ptr;
   current_status : Status;
   ball_holder_id : Integer;
   game_status : Game_State;

   init_players_count : Integer;
   team_one_players_count : Integer;
   team_two_players_count : Integer;
   initialized : Boolean;

   first_time : Boolean;

   checkpoint_time : Time;

end Soccer.ControllerPkg;
