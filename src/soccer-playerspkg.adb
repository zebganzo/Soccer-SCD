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

   type Rand_Range is range 1 .. 8;
   package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);

   --
   --     Rand_Int.Reset(seedX); Integer(Rand_Int.Random(seedX)
   --     Rand_Int.Reset(seedY); Integer(Rand_Int.Random(seedY))

   pass_range : Integer := 3;
   tackle_range : Integer := 2;

   procedure Update_Distence (index : in Integer; players : in out Vector; distance : in Integer) is
      procedure Set_New_Distance (Element : in out PlayerStatus)  is
      begin
         Element.distance := distance;
      end Set_New_Distance;
   begin
      players.Update_Element(index, Set_New_Distance'Access);
   end Update_Distence;

   task body Player is
      mCoord : Coordinate;
      mTargetCoord : Coordinate;
      mReadResult : ReadResult;
      mGenericStatus : Generic_Status_Ptr;
      mRange : Integer;
      mAction : Action;
      seedX : Rand_Int.Generator;
      seedY : Rand_Int.Generator;
   begin

      Rand_Int.Reset(seedX);
      Rand_Int.Reset(seedY);

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

         for i in mReadResult.playersInMyZone.First_Index .. mReadResult.playersInMyZone.Last_Index loop
            declare
               other_coord : Coordinate;
            begin
               other_coord := mReadResult.playersInMyZone.Element(Index => i).mCoord;
               Update_Distence(index       => i,
                               players  => mReadResult.playersInMyZone,
                               distance => Utils.Distance(From => mCoord,
                                                          To   => other_coord));

            end;
         end loop;

         Put_Line("Ciao sono " & I2S(id) & " mGenericStatus.nearby : " & Boolean'Image(mGenericStatus.nearby));

         if mGenericStatus.holder then
            -- Che bello ho la palla, se sono in pericolo la passo se no fanculo tutti!
            declare
               foundPlayer : Boolean := False;
            begin
               for i in mReadResult.playersInMyZone.First_Index .. mReadResult.playersInMyZone.Last_Index loop
                  if mReadResult.playersInMyZone.Element(Index => i).team.id /= team.id and
                    mReadResult.playersInMyZone.Element(Index => i).distance <= pass_range then
                     foundPlayer := True;
                  end if;
               end loop;

               if foundPlayer then
                  declare
                     playerTarget : Integer := -1;
                  begin
                     for i in mReadResult.playersInMyZone.First_Index .. mReadResult.playersInMyZone.Last_Index loop
                        if mReadResult.playersInMyZone.Element(Index => i).team.id = team.id and
                          mReadResult.playersInMyZone.Element(Index => i).distance <= 10 then -- tutti con la stessa forza di tiro
                           playerTarget := i;
                        end if;
                     end loop;

                     if playerTarget = -1 then
                        declare
                           target : Coordinate := Utils.Get_Random_Target(coord => mCoord);
                        begin

                           mAction.event := new Move_Event;
                           mAction.event.Initialize(nPlayer_Id => Id,
                                                    nFrom      => mCoord,
                                                    nTo        => target);
                           mAction.utility := 10;
                           ControllerPkg.Controller.Write(mAction => mAction);
                        end;
                     else
                        mAction.event := new Shot_Event;
                        mAction.event.Initialize(Id, mCoord,
                                                 mReadResult.playersInMyZone.Element(Index => playerTarget).mCoord);
                        Put_Line("Mi stanno per rubare palla, la passo al mio amico " & I2S(mReadResult.playersInMyZone.Element(Index => playerTarget).id));
                        Shot_Event_Prt(mAction.event).Set_Shot_Power (10);
                        mAction.utility := 10;
                        ControllerPkg.Controller.Write(mAction => mAction);
                     end if;
                  end;
               else
                  declare
                     target : Coordinate := Utils.Get_Random_Target(coord => mCoord);
                  begin

                     mAction.event := new Move_Event;
                     mAction.event.Initialize(nPlayer_Id => Id,
                                              nFrom      => mCoord,
                                              nTo        => target);
                     mAction.utility := 10;
                     ControllerPkg.Controller.Write(mAction => mAction);
                  end;
               end if;
            end;
         elsif mGenericStatus.nearby then
            -- Sono vicnino alla palla! Meglio essere coscienziosi
            if Compare_Coordinates(coord1 => Ball.Get_Position,
                                   coord2 => mCoord) then
               mAction.event := new Catch_Event;
               mAction.event.Initialize(Id, mCoord,
                                        Ball.Get_Position);
               mAction.utility := 10;
               ControllerPkg.Controller.Write(mAction => mAction);
            else
               if Ball.Get_Controlled then
                  declare
                     targetPlayer : Coordinate := Coordinate'(coordX => 0,
                                                              coordY => 0);
                     targetPlayerId : Integer := 0;
                  begin
                     -- controllata da un giocatore
                     for i in mReadResult.playersInMyZone.First_Index .. mReadResult.playersInMyZone.Last_Index loop
                        if mReadResult.playersInMyZone.Element(Index => i).id = mReadResult.holder_id then
                           if mReadResult.playersInMyZone.Element(Index => i).team.id /= team.id then
                              -- la controlla un avversario
                              targetPlayer := mReadResult.playersInMyZone.Element(Index => i).mCoord;
                              targetPlayerId := mReadResult.playersInMyZone.Element(Index => i).id;
                           end if;
                        end if;
                     end loop;
                     if targetPlayer.coordX = 0 then
                        -- la controlla un compagno di squadra -> mi muovo a caso!
                        declare
                           target : Coordinate := Utils.Get_Random_Target(coord => mCoord);
                        begin

                           mAction.event := new Move_Event;
                           mAction.event.Initialize(nPlayer_Id => Id,
                                                    nFrom      => mCoord,
                                                    nTo        => target);
                           mAction.utility := 10;
                           ControllerPkg.Controller.Write(mAction => mAction);
                        end;
                     else
                        if Utils.Distance(From => mCoord,
                                          To   => targetPlayer) = 1 then
                           -- tackle!
                           mAction.event := new Tackle_Event;
                           mAction.event.Initialize(Id, mCoord,
                                                    targetPlayer);
                           Tackle_Event_Prt(mAction.event).Set_Other_Player_Id(id => targetPlayerId);
                           mAction.utility := 10;
                           ControllerPkg.Controller.Write(mAction => mAction);
                        else
                           -- mi sposto verso di lui!!
                           mAction.event := new Move_Event;
                           mAction.event.Initialize(nPlayer_Id => Id,
                                                    nFrom      => mCoord,
                                                    nTo        => Utils.Get_Next_Coordinate(myCoord     => mCoord,
                                                                                            targetCoord => targetPlayer));
                           mAction.utility := 10;
                           ControllerPkg.Controller.Write(mAction => mAction);
                        end if;
                     end if;
                  end;
               end if;

            end if;
         else
            -- Mi muovo a caso!
            declare
               target : Coordinate := Utils.Get_Random_Target(coord => mCoord);
            begin

               mAction.event := new Move_Event;
               mAction.event.Initialize(nPlayer_Id => Id,
                                        nFrom      => mCoord,
                                        nTo        => target);
               mAction.utility := 10;
               ControllerPkg.Controller.Write(mAction => mAction);
            end;
         end if;


         delay duration (2);
      end loop;
   end Player;
end Soccer.PlayersPkg;
