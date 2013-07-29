with Ada.Containers.Vectors; use Ada.Containers;
with Soccer.Core_Event.Motion_Core_Event; use Soccer.Core_Event.Motion_Core_Event;

with Soccer.Manager_Event.Substitution; use Soccer.Manager_Event.Substitution;

with Soccer.TeamPkg; use Soccer.TeamPkg;
with Soccer.Core_Event.Game_Core_Event; use Soccer.Core_Event.Game_Core_Event;

package Soccer.ControllerPkg is

   -- New Types

   type Action is
      record
         event : Motion_Event_Ptr;
         utility : Utility_Range;
      end record;

   type Player_Status is
      record
         id : Integer;
         team : Team_Id;
         running : Boolean := False;
         on_the_field : Boolean := False;
         player_coord : Coordinate := Coordinate'(coord_x => 0,
                                            coord_y => 0);
         distance : Integer;
      end record;

   type Status is array (1 .. num_of_players) of Player_Status;

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
         holder : Boolean;
	 nearby : Boolean;
	 game_status : Game_Event_Ptr;
	 game_ready : Boolean;
	 substitutions : Substitutions_Container.Vector;
      end record;
   type Generic_Status_Ptr is access Generic_Status;

   -- Functions, Procedure, ecc...

   function Get_Generic_Status (id : in Integer) return Generic_Status_Ptr;

   procedure Set_Game_Status (event : Game_Event_Ptr);

   procedure Set_Game_Ready (status : in Boolean);

   function Get_Game_Ready return Boolean;

   function Get_Game_Status return Game_Event_Ptr;

   function Is_Game_Running return Boolean;

   function Get_Players_Status return Status;

   function Read_Status (x : in Integer; y : in Integer; r : in Integer) return Read_Result;

   task Field_Printer;

   number_of_zones : Integer := 3;

   type Field_Zones is new Integer range 1 .. number_of_zones;
   type Released_Zones is array (1 .. number_of_zones) of Boolean;

   task Controller is
      entry Write(current_action : in out Action);
   private
      entry Awaiting(Field_Zones)(current_action : in out Action);
   end Controller;

private
   game_status : Game_Event_Ptr;
   current_status : Status;
   ball_holder_id : Integer := 0;
   is_game_ready : Boolean;

end Soccer.ControllerPkg;
