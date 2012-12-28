with Ada.Text_IO;
use Ada.Text_IO;

with Soccer.ControllerPkg;
use Soccer.ControllerPkg;

with Ada.Numerics;
with Ada.Numerics.Discrete_Random;

with Soccer.Utils;
use Soccer.Utils;

with Soccer.Core_Event.Motion_Core_Event.Catch_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Catch_Motion_Event;
with Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;
with Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event;
with Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;

package body Soccer.PlayersPkg is

   use Players_Container;

   --     type Rand_Range is range -1 .. 1;
   --     package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);
   --     seedX : Rand_Int.Generator;
   --     seedY : Rand_Int.Generator;
   --     Rand_Int.Reset(seedX); Integer(Rand_Int.Random(seedX)
   --     Rand_Int.Reset(seedY); Integer(Rand_Int.Random(seedY))


   task body Player is
      mCoord : Coordinate;
      mTargetCoord : Coordinate;
      mReadResult : ReadResult;
      mAction : Action;
   begin
--        Put_Line("Init giocatore " & I2S(Id));

      mTargetCoord := Coordinate'(coordX => Id,--Field_Max_X / 2,
                                  coordY => 1);

--        mTargetCoord := Coordinate'(coordX => Id,
--                                    coordY => 5);

      mAction.event := new Move_Event;
      mCoord := ControllerPkg.getMyPosition(id => Id);
      mAction.event.Initialize(nPlayer_Id => Id,
                               nFrom      => mCoord,
                               nTo        => mTargetCoord);
      mAction.utility := 10;

      ControllerPkg.Controller.Write(mAction => mAction);

--        mCoord := ControllerPkg.getMyPosition(id => Id);
--        Put_Line("Giocatore " & I2S(Id) & " Coordinate " & I2S(mCoord.coordX) & "," & I2S(mCoord.coordY));
--
--        Put_Line("End Init giocatore " & I2S(Id));

      delay duration(5);

      loop
--           Put_Line("Turno giocatore " & I2S(Id));
         mCoord := ControllerPkg.getMyPosition(id => Id);
--           Put_Line("Giocatore " & I2S(Id) & " Coordinate From " & I2S(mCoord.coordX) & "," & I2S(mCoord.coordY));

         mReadResult := ControllerPkg.readStatus(x => mCoord.coordX,
                                                 y => mCoord.coordY,
                                                 r => ability);

         --+ Stampa dei giocatori nelle mie vicinanze
         --for i in mReadResult.playersInMyZone.First_Index .. mReadResult.playersInMyZone.Last_Index loop
         --   Put_Line("- " & I2S(mReadResult.playersInMyZone.Element(Index => i).id));
         --end loop;

         mTargetCoord := Utils.getNextCoordinate(myCoord     => mCoord,
                                                 targetCoord => Initial_Coord);

--           Put_Line("Giocatore " & I2S(Id) & " Coordinate To " & I2S(mTargetCoord.coordX) & "," & I2S(mTargetCoord.coordY));

         mAction.event := new Move_Event;

         mAction.event.Initialize(nPlayer_Id => Id,
                                  nFrom      => mCoord,
                                  nTo        => mTargetCoord);
         mAction.utility := 6;

         ControllerPkg.Controller.Write(mAction => mAction);
--           Put_Line("Fine turno giocatore " & I2S(Id));
         delay duration (2);
      end loop;
   end Player;
end Soccer.PlayersPkg;
