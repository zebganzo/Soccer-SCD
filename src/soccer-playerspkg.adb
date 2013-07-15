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

   procedure Update_Distance (index : in Integer; players : in out Vector; distance : in Integer) is
      procedure Set_New_Distance (Element : in out Player_Status)  is
      begin
         Element.distance := distance;
      end Set_New_Distance;
   begin
      players.Update_Element(index, Set_New_Distance'Access);
   end Update_Distance;

   task body Player is
      current_coord : Coordinate;
      target_coord : Coordinate;
      current_read_result : Read_Result;
      current_generic_status : Generic_Status_Ptr;
      current_range : Integer;
      current_action : Action;
      seed_x : Rand_Int.Generator;
      seed_y : Rand_Int.Generator;
   begin

      Rand_Int.Reset(seed_x);
      Rand_Int.Reset(seed_y);

      target_coord := Coordinate'(coordX => initial_coord_x,
                                  coordY => initial_coord_y);

      current_action.event := new Move_Event;
      current_generic_status := ControllerPkg.Get_Generic_Status(id => id);
      current_coord := current_generic_status.coord;
      current_action.event.Initialize(nPlayer_Id => id,
                               nFrom      => current_coord,
                               nTo        => target_coord);
      current_action.utility := 10;

      ControllerPkg.Controller.Write(current_action => current_action);

      delay duration(5);

      loop

         current_generic_status := ControllerPkg.Get_Generic_Status(id => id);
         current_coord := current_generic_status.coord;

         if current_generic_status.holder then
            current_range := ability;
         elsif current_generic_status.nearby then
            current_range := nearby_distance;
         else
            current_range := 1;
         end if;

         --       Put_Line("Giocatore " & I2S(Id) & " Coordinate From " & I2S(mCoord.coordX) & "," & I2S(mCoord.coordY));

         current_read_result := ControllerPkg.Read_Status(x => current_coord.coordX,
                                                 y => current_coord.coordY,
                                                 r => current_range);

         for i in current_read_result.players_in_my_zone.First_Index .. current_read_result.players_in_my_zone.Last_Index loop
            declare
               other_coord : Coordinate;
            begin
               other_coord := current_read_result.players_in_my_zone.Element(Index => i).player_coord;
               Update_Distance(index       => i,
                               players  => current_read_result.players_in_my_zone,
                               distance => Utils.Distance(From => current_coord,
                                                          To   => other_coord));

            end;
         end loop;

         Put_Line("Ciao sono " & I2S(id) & " mGenericStatus.nearby : " & Boolean'Image(current_generic_status.nearby));

         if current_generic_status.holder then
            -- Che bello ho la palla, se sono in pericolo la passo se no fanculo tutti!
            declare
               foundPlayer : Boolean := False;
            begin
               for i in current_read_result.players_in_my_zone.First_Index .. current_read_result.players_in_my_zone.Last_Index loop
                  if current_read_result.players_in_my_zone.Element(Index => i).team /= team and
                    current_read_result.players_in_my_zone.Element(Index => i).distance <= pass_range then
                     foundPlayer := True;
                  end if;
               end loop;

               if foundPlayer then
                  declare
                     playerTarget : Integer := -1;
                  begin
                     for i in current_read_result.players_in_my_zone.First_Index .. current_read_result.players_in_my_zone.Last_Index loop
                        if current_read_result.players_in_my_zone.Element(Index => i).team = team and
                          current_read_result.players_in_my_zone.Element(Index => i).distance <= 10 then -- tutti con la stessa forza di tiro
                           playerTarget := i;
                        end if;
                     end loop;

                     if playerTarget = -1 then
                        declare
                           target : Coordinate := Utils.Get_Random_Target(coord => current_coord);
                        begin

                           current_action.event := new Move_Event;
                           current_action.event.Initialize(nPlayer_Id => id,
                                                    nFrom      => current_coord,
                                                    nTo        => target);
                           current_action.utility := 10;
                           ControllerPkg.Controller.Write(current_action => current_action);
                        end;
                     else
                        current_action.event := new Shot_Event;
                        current_action.event.Initialize(id, current_coord,
                                                 current_read_result.players_in_my_zone.Element(Index => playerTarget).player_coord);
                        Put_Line("Mi stanno per rubare palla, la passo al mio amico " & I2S(current_read_result.players_in_my_zone.Element(Index => playerTarget).id));
                        Shot_Event_Prt(current_action.event).Set_Shot_Power (10);
                        current_action.utility := 10;
                        ControllerPkg.Controller.Write(current_action => current_action);
                     end if;
                  end;
               else
                  declare
                     target : Coordinate := Utils.Get_Random_Target(coord => current_coord);
                  begin

                     current_action.event := new Move_Event;
                     current_action.event.Initialize(nPlayer_Id => id,
                                              nFrom      => current_coord,
                                              nTo        => target);
                     current_action.utility := 10;
                     ControllerPkg.Controller.Write(current_action => current_action);
                  end;
               end if;
            end;
         elsif current_generic_status.nearby then
            -- Sono vicnino alla palla! Meglio essere coscienziosi
            if Compare_Coordinates(coord1 => Ball.Get_Position,
                                   coord2 => current_coord) then
               current_action.event := new Catch_Event;
               current_action.event.Initialize(id, current_coord,
                                        Ball.Get_Position);
               current_action.utility := 10;
               ControllerPkg.Controller.Write(current_action => current_action);
            else
               if Ball.Get_Controlled then
                  declare
                     targetPlayer : Coordinate := Coordinate'(coordX => 0,
                                                              coordY => 0);
                     targetPlayerId : Integer := 0;
                  begin
                     -- controllata da un giocatore
                     for i in current_read_result.players_in_my_zone.First_Index .. current_read_result.players_in_my_zone.Last_Index loop
                        if current_read_result.players_in_my_zone.Element(Index => i).id = current_read_result.holder_id then
                           if current_read_result.players_in_my_zone.Element(Index => i).team /= team then
                              -- la controlla un avversario
                              targetPlayer := current_read_result.players_in_my_zone.Element(Index => i).player_coord;
                              targetPlayerId := current_read_result.players_in_my_zone.Element(Index => i).id;
                           end if;
                        end if;
                     end loop;
                     if targetPlayer.coordX = 0 then
                        -- la controlla un compagno di squadra -> mi muovo a caso!
                        declare
                           target : Coordinate := Utils.Get_Random_Target(coord => current_coord);
                        begin

                           current_action.event := new Move_Event;
                           current_action.event.Initialize(nPlayer_Id => id,
                                                    nFrom      => current_coord,
                                                    nTo        => target);
                           current_action.utility := 10;
                           ControllerPkg.Controller.Write(current_action => current_action);
                        end;
                     else
                        if Utils.Distance(From => current_coord,
                                          To   => targetPlayer) = 1 then
                           -- tackle!
                           current_action.event := new Tackle_Event;
                           current_action.event.Initialize(id, current_coord,
                                                    targetPlayer);
                           Tackle_Event_Prt(current_action.event).Set_Other_Player_Id(id => targetPlayerId);
                           current_action.utility := 10;
                           ControllerPkg.Controller.Write(current_action => current_action);
                        else
                           -- mi sposto verso di lui!!
                           current_action.event := new Move_Event;
                           current_action.event.Initialize(nPlayer_Id => id,
                                                    nFrom      => current_coord,
                                                    nTo        => Utils.Get_Next_Coordinate(myCoord     => current_coord,
                                                                                            targetCoord => targetPlayer));
                           current_action.utility := 10;
                           ControllerPkg.Controller.Write(current_action => current_action);
                        end if;
                     end if;
                  end;
               else
                  current_action.event := new Move_Event;
                  current_action.event.Initialize(nPlayer_Id => id,
                                           nFrom      => current_coord,
                                           nTo        => Utils.Get_Next_Coordinate(myCoord     => current_coord,
                                                                                   targetCoord => Ball.Get_Position));
                  current_action.utility := 10;
                  ControllerPkg.Controller.Write(current_action => current_action);
               end if;
            end if;
         else
            -- Mi muovo a caso!
            declare
               target : Coordinate := Utils.Get_Random_Target(coord => current_coord);
            begin

               current_action.event := new Move_Event;
               current_action.event.Initialize(nPlayer_Id => id,
                                        nFrom      => current_coord,
                                        nTo        => target);
               current_action.utility := 10;
               ControllerPkg.Controller.Write(current_action => current_action);
            end;
         end if;


         delay duration (2);
      end loop;

   end Player;
end Soccer.PlayersPkg;
