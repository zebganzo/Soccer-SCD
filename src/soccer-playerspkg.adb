with Ada.Text_IO, Soccer.ControllerPkg;
use Ada.Text_IO, Soccer.ControllerPkg;
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

      Put_Line("Prima " & I2S(Id));

--        mTargetCoord := Coordinate'(coordX => Field_Max_X / 2,
--                                    coordY => 1);

      mTargetCoord := Coordinate'(coordX => Id,
                                  coordY => 5);

      mAction.event := new Move_Event;
      mCoord := ControllerPkg.getMyPosition(id => Id);
      mAction.event.Initialize(nPlayer_Id => Id,
                               nFrom      => mCoord,
                               nTo        => mTargetCoord);
      mAction.utility := 10;

      ControllerPkg.Controller.Write(mAction => mAction);

      Put_Line("Dopo " & I2S(Id));

      loop
         mCoord := ControllerPkg.getMyPosition(id => Id);
         mReadResult := ControllerPkg.readStatus(x => mCoord.coordX,
                                                 y => mCoord.coordY,
                                                 r => ability);

         --+ Stampa dei giocatori nelle mie vicinanze
         --for i in mReadResult.playersInMyZone.First_Index .. mReadResult.playersInMyZone.Last_Index loop
         --   Put_Line("- " & I2S(mReadResult.playersInMyZone.Element(Index => i).id));
         --end loop;

         Initial_Coord.coordX := mCoord.coordX + 1;
         Initial_Coord.coordY := mCoord.coordY;
         mTargetCoord := Utils.getNextCoordinate(myCoord     => mCoord,
                                                 targetCoord => Initial_Coord);

         mAction.event := new Move_Event;

         mAction.event.Initialize(nPlayer_Id => Id,
                                  nFrom      => mCoord,
                                  nTo        => mTargetCoord);
         mAction.utility := 6;

         ControllerPkg.Controller.Write(mAction => mAction);
         delay duration (Id);
      end loop;
   end Player;
end Soccer.PlayersPkg;
