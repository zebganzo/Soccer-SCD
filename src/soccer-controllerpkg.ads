with Ada.Containers.Vectors;
use Ada.Containers;

package Soccer.ControllerPkg is

   procedure PrintField;

   fieldMaxX : Integer := 15;
   fieldMaxY : Integer := 10;
   subtype utilityRange is Integer range 1 .. 10;
   subtype utilityConstraint is utilityRange;

   type CellType is
      record
         id : Integer := 0;
         coordX   : Integer range 1 .. fieldMaxX;
         coordY   : Integer range 1 .. fieldMaxY;
      end record;

   type Cell is access CellType;

   function getMyPosition (id : in Integer) return Cell;

   --+ DA COMPLETARE
   type Action is
      record
         byWho : Integer;
         cellTarget : Cell;
         utility : utilityRange;
      end record;

   package Players_Container is new Vectors (Index_Type   => Natural,
                                             Element_Type => Cell);
   use Players_Container;

   type ReadResultType is
      record
         playersInMyZone : Vector;
      end record;
   type ReadResult is access ReadResultType;
   function readStatus (x : in Integer; y : in Integer; r : in Integer) return ReadResult;

   task Controller is
      entry Write(mAction : in Action);
   private
      entry Awaiting(mAction : in Action);
   end Controller;

end Soccer.ControllerPkg;
