with Ada.Containers.Vectors;
use Ada.Containers;
with Soccer.Core_Event.Motion_Core_Event;
use Soccer.Core_Event.Motion_Core_Event;

with Soccer.TeamPkg;
use Soccer.TeamPkg;
with Soccer.Core_Event.Game_Core_Event;
use Soccer.Core_Event.Game_Core_Event;

package Soccer.ControllerPkg is

   -- New Types

   type Action is
      record
         event : Motion_Event_Prt;
         utility : Utility_Range;
      end record;

   type Player_Status is
      record
         id : Integer;
         team : Team_Id;
         running : Boolean := False;
         on_the_field : Boolean := False;
         player_coord : Coordinate := Coordinate'(coordX => 0,
                                            coordY => 0);
         distance : Integer;
      end record;

   package Players_Container is new Vectors (Index_Type   => Natural,
                                             Element_Type => Player_Status);
   use Players_Container;

   type Read_Result_Type is
      record
         players_in_my_zone : Vector;
         holder_id : Integer;
      end record;
   type Read_Result is access Read_Result_Type;

   type Generic_Status is
      record
         coord : Coordinate;
         holder : Boolean;
	 nearby : Boolean;
	 last_event : Game_Event;
      end record;
   type Generic_Status_Ptr is access Generic_Status;

   -- Functions, Procedure, ecc...

   function Get_Generic_Status (id : in Integer) return Generic_Status_Ptr;

   procedure Set_Last_Event (event : Game_Event_Prt);

   function Read_Status (x : in Integer; y : in Integer; r : in Integer) return Read_Result;

   task Field_Printer;

   Num_Of_Zone : Integer := 3;

   type Fields_Zone is new Integer range 1 .. Num_Of_Zone;

   task Controller is
      entry Write(current_action : in out Action);
   private
      entry Awaiting(Fields_Zone)(current_action : in out Action);
   end Controller;

private
   last_event : Game_Event_Prt;

end Soccer.ControllerPkg;
