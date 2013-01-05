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
with Soccer.BallPkg; use Soccer.BallPkg;

package body Soccer.PlayersPkg is

   use Players_Container;

   type Rand_Range is range 1 .. 100;
   package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);

   --     seedY : Rand_Int.Generator;
   --     Rand_Int.Reset(seedX); Integer(Rand_Int.Random(seedX)
   --     Rand_Int.Reset(seedY); Integer(Rand_Int.Random(seedY))

   task body Player is
      mCoord : Coordinate;
      mTargetCoord : Coordinate;
      mReadResult : ReadResult;
      mGenericStatus : Generic_Status_Ptr;
      mRange : Integer;
      mAction : Action;
      mRandomPlayer : Integer;
      seedX : Rand_Int.Generator;
   begin

      Rand_Int.Reset(seedX);

      mTargetCoord := Coordinate'(coordX => Initial_Coord_X,
                                  coordY => Initial_Coord_Y);

      mAction.event := new Move_Event;
      mGenericStatus := ControllerPkg.Get_Generic_Status(id => Id);
      mCoord := mGenericStatus.coord;
      mAction.event.Initialize(nPlayer_Id => Id,
                               nFrom      => mCoord,
                               nTo        => mTargetCoord);
      mAction.utility := 10;

      ControllerPkg.Controller.Write(mAction => mAction);

      delay duration(5);

      loop

         mGenericStatus := ControllerPkg.Get_Generic_Status(id => Id);
         mCoord := mGenericStatus.coord;

         if mGenericStatus.holder then
            mRange := Ability;
         elsif mGenericStatus.nearby then
            mRange := Nearby_Distance;
         else
            mRange := 1;
         end if;

--       Put_Line("Giocatore " & I2S(Id) & " Coordinate From " & I2S(mCoord.coordX) & "," & I2S(mCoord.coordY));

         mReadResult := ControllerPkg.readStatus(x => mCoord.coordX,
                                                 y => mCoord.coordY,
                                                 r => mRange);

--           for i in mReadResult.playersInMyZone.First_Index .. mReadResult.playersInMyZone.Last_Index loop
--                 Put_Line("- " & I2S(mReadResult.playersInMyZone.Element(Index => i).id));
--              end loop;

         if id = 1 then
            Put_Line("Ciao sono 1, ho la palla? " & Boolean'Image(mGenericStatus.holder));
         end if;

         if mGenericStatus.holder then
            mAction.event := new Shot_Event;
            mRandomPlayer := (Integer(Rand_Int.Random(seedX)) rem mReadResult.playersInMyZone.Last_Index) + 1;
            mAction.event.Initialize(Id, mCoord,
                                     mReadResult.playersInMyZone.Element(Index => mRandomPlayer).mCoord);
            Put_Line("La passero' al mio amico " & I2S(mReadResult.playersInMyZone.Element(Index => mRandomPlayer).id));
            Shot_Event_Prt(mAction.event).Set_Shot_Power (10);
            mAction.utility := 10;
            ControllerPkg.Controller.Write(mAction => mAction);
         elsif mGenericStatus.nearby then
            if Compare_Coordinates(coord1 => Ball.Get_Position,
                                   coord2 => mCoord) then
               mAction.event := new Catch_Event;
               mAction.event.Initialize(Id, mCoord,
                                        Ball.Get_Position);
               mAction.utility := 10;
               ControllerPkg.Controller.Write(mAction => mAction);
            end if;
         end if;
         --+ Stampa dei giocatori nelle mie vicinanze


--           mTargetCoord := Utils.Get_Next_Coordinate(myCoord     => mCoord,
--                                                     targetCoord => Initial_Coord);

--           Put_Line("Giocatore " & I2S(Id) & " Coordinate To " & I2S(mTargetCoord.coordX) & "," & I2S(mTargetCoord.coordY));

--           mAction.event := new Move_Event;
--
--           mAction.event.Initialize(nPlayer_Id => Id,
--                                    nFrom      => mCoord,
--                                    nTo        => mTargetCoord);
--           mAction.utility := 6;
--
--           ControllerPkg.Controller.Write(mAction => mAction);
         delay duration (2);
      end loop;
   end Player;
end Soccer.PlayersPkg;
