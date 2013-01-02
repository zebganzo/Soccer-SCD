with Ada.Containers.Vectors;
use Ada.Containers;
with Soccer.Core_Event.Motion_Core_Event;
use Soccer.Core_Event.Motion_Core_Event;

package Soccer.ControllerPkg is

   -- New Types

   type Action is
      record
         event : Motion_Event_Prt;
         utility : Utility_Range;
      end record;

   type PlayerStatus is
      record
         id : Integer;
         running : Boolean := False;
         on_the_field : Boolean := False;
         mCoord : Coordinate := Coordinate'(coordX => 0,
                                            coordY => 0);
         ball_holder : Boolean := False;
      end record;

   package Players_Container is new Vectors (Index_Type   => Natural,
                                             Element_Type => PlayerStatus);
   use Players_Container;

   type ReadResultType is
      record
         playersInMyZone : Vector;
      end record;
   type ReadResult is access ReadResultType;

   -- Functions, Procedure, ecc...

   function getMyPosition (id : in Integer) return Coordinate;

   function readStatus (x : in Integer; y : in Integer; r : in Integer) return ReadResult;

   task Field_Printer;

   Num_Of_Zone : Integer := 3;

   type Fields_Zone is new Integer range 1 .. Num_Of_Zone;

   task Controller is
      entry Write(mAction : in out Action);
   private
      entry Awaiting(Fields_Zone)(mAction : in out Action);
   end Controller;

end Soccer.ControllerPkg;
