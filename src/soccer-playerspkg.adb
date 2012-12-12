with Ada.Text_IO, Soccer.ControllerPkg;
use Ada.Text_IO, Soccer.ControllerPkg;
with Ada.Numerics;
with Ada.Numerics.Discrete_Random;

package body Soccer.PlayersPkg is

   use Players_Container;

   task body Player is
      mCell : Cell;
      mReadResult : ReadResult;

      mAction : Action;

      type Rand_Range is range -1 .. 1;
      package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);
      seedX : Rand_Int.Generator;
      seedY : Rand_Int.Generator;
   begin
      mAction.cellTarget := new CellType;
      loop
         Put_Line("Ciao " & I2S(Id));
         mCell := ControllerPkg.getMyPosition(id => Id);
         mReadResult := ControllerPkg.readStatus(x => mCell.coordX,
                                                 y => mCell.coordY,
                                                 r => ability);
         for i in mReadResult.playersInMyZone.First_Index .. mReadResult.playersInMyZone.Last_Index loop
            Put_Line("- " & I2S(mReadResult.playersInMyZone.Element(Index => i).id));
         end loop;
         Rand_Int.Reset(seedX);
         Rand_Int.Reset(seedY);
         mCell.coordX := mCell.coordX + Integer(Rand_Int.Random(seedX));
         mCell.coordY := mCell.coordY + Integer(Rand_Int.Random(seedY));
         mAction.byWho := Id;
         mAction.cellTarget.coordX := mCell.coordX;
         mAction.cellTarget.coordY := mCell.coordY;
         mAction.utility := 6;
         delay duration (2);
      end loop;
   end Player;
end Soccer.PlayersPkg;
