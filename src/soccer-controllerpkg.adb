with Ada.Text_IO; use Ada.Text_IO;

with Soccer.Utils;
use Soccer.Utils;

--  with Soccer.ControllerPkg.Referee;
--  use Soccer.ControllerPkg.Referee;

with Ada.Numerics.Generic_Elementary_Functions;
with Soccer.Bridge.Output; use Soccer.Bridge.Output;
with Soccer.Manager_Event; use Soccer.Manager_Event;
with Soccer.BallPkg; use Soccer.BallPkg;
with Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;
with Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event;
with Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;
with Soccer.Core_Event.Motion_Core_Event.Catch_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Catch_Motion_Event;
with Soccer.Motion_AgentPkg; use Soccer.Motion_AgentPkg;
with Ada.Numerics.Discrete_Random;
with Soccer.ControllerPkg; use Soccer.ControllerPkg;

package body Soccer.ControllerPkg is

   type Status is array (1 .. Num_Of_Player) of PlayerStatus;
   mStatus : Status;

   ball_holder_id : Integer := 0;

   type Released_Zone is array (1 .. Num_Of_Zone) of Boolean;

   --+ Ritorna la posizione in base all'id
   function Get_Generic_Status(id : in Integer) return Generic_Status_Ptr is
      coord_result : Coordinate;
      holder_result : Boolean := False;
      nearby_result : Boolean := False;
      gen_stat : Generic_Status_Ptr := new Generic_Status;
   begin
      for i in mStatus'Range loop
         if(mStatus(i).id = id) then
            coord_result := mStatus(i).mCoord;
            if(ball_holder_id = mStatus(i).id) then
               holder_result := True;
            elsif Distance(From => Ball.Get_Position,
                           To   => mStatus(i).mCoord) <= Nearby_Distance then
               nearby_result := True;
            else
               nearby_result := False;
            end if;
            exit;
         end if;
      end loop;
      gen_stat.coord := coord_result;
      gen_stat.holder := holder_result;
      gen_stat.nearby := nearby_result;
      return gen_stat;
   end Get_Generic_Status;

   --+ Ritorna un Vector di Coordinate (id, x, y) dei giocatori di distanza <= a r
   function readStatus (x : in Integer; y : in Integer; r : in Integer) return ReadResult is
      result : ReadResult := new ReadResultType;
      d : Integer := 0;
   begin
      for i in mStatus'Range loop
         d := Distance(x1 => x,
                       x2 => mStatus(i).mCoord.coordX,
                       y1 => y,
                       y2 => mStatus(i).mCoord.coordY);
         if(d <= r and d /= 0) then
            result.playersInMyZone.Append(New_Item => mStatus(i));
         end if;
      end loop;
      result.holder_id := ball_holder_id;
      return result;
   end readStatus;

   --+ Controlla se in quella cella c'e' un giocatore
   function HereIsAPlayer(x : in Integer; y : in Integer) return Integer is
   begin
      for i in mStatus'Range loop
         if (mStatus(i).mCoord.coordX = x and mStatus(i).mCoord.coordY = y) then
            if(mStatus(i).id = ball_holder_id) then
               return -1 * mStatus(i).id;
            else
               return mStatus(i).id;
            end if;
         end if;
      end loop;
      if Ball.Get_Position.coordX = x and Ball.Get_Position.coordY = y then
         return 100;
      end if;
      return 0;
   end HereIsAPlayer;

   --+ Inizializza l'array Status con l'id di ogni giocatore
   procedure Initialize is
   begin
      for i in 1 .. Num_Of_Player loop
         mStatus(i).id := i;
         if i < 4 then
            mStatus(i).team := TeamPkg.Team_One;
         else
            mStatus(i).team := TeamPkg.Team_Two;
         end if;
      end loop;
   end Initialize;

   --+ Stampa del campo
   procedure PrintField is
      cell : Integer;
   begin
      --Utils.CLS;

      for i in  1 .. Field_Max_X + 1 loop
         Put("-");
      end loop;
      Put_Line("");
      for y in reverse 1 .. Field_Max_Y loop
         Put("|");
         for x in 1 .. Field_Max_X loop
            cell := HereIsAPlayer(x => x, y => y);
            if cell = 0 then
               Put(" ");
            elsif cell = 100 then
               Put ("*");
            else
               if(cell < 0) then
                  Put ("*" & I2S (cell));
               else
                  Put("" & I2S(cell));
               end if;
            end if;
         end loop;
         Put("|");
         Put_Line("");
      end loop;
      for i in  1 .. Field_Max_X + 1 loop
         Put("-");
      end loop;
      Put_Line("");
   end PrintField;

   task body Field_Printer is
   begin
      loop
         PrintField;
         delay duration (1);
      end loop;
   end Field_Printer;

   Released : Released_Zone;

   function getZone (coord : Coordinate) return Integer is
   begin
      return (Integer(coord.coordX / (Field_Max_X / Num_Of_Zone)) + 1);
   end getZone;

   procedure Release (coord : Coordinate) is
   begin
      Released(getZone(coord => coord)) := True;
   end Release;

   function Occupy (coord : Coordinate) return Fields_Zone is
      Zone : Fields_Zone;
   begin
      Zone := Fields_Zone(getZone(coord => coord));
      Released(Integer(Zone)) := False;
      return Zone;
   end Occupy;

   type Rand_Range is range 1 .. 10;
   package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);

   function Calculate_Tackle (attacker_id : in Integer; ball_owner_id : in Integer) return Boolean is
      tackle_seed : Rand_Int.Generator;
   begin
      Rand_Int.Reset(tackle_seed);
      if Integer(Rand_Int.Random(tackle_seed)) > 5 then
         return True;
      else
         return False;
      end if;
   end Calculate_Tackle;

   --+ Nel caso in cui il giocatore si sposti con la palla non cambia la mossa scritta nel buffer
   --+dovra' essere lato distribuzione interpolare se la palla e' ancora in possesso di un giocatore
   --+ o se si sta spostando con l'agente di movimento, ecc. ecc.
   procedure Compute (action : in Move_Event_Prt; success : out Boolean) is
      here_player_result : Integer;
   begin
      here_player_result := HereIsAPlayer(x => action.getTo.coordX,
                                          y => action.getTo.coordY);
      if here_player_result = 0 or here_player_result = 100 then
         -- Free position
         mStatus(action.getPlayer_Id).mCoord := action.getTo;
         if ball_holder_id = action.getPlayer_Id then
            Ball.Move_Player(new_coord => action.getTo);
         end if;
         Buffer_Wrapper.Put(new_event => Core_Event.Event_Ptr (action));

         Release(action.getFrom);
         success := True;
      else
         success := False;
      end if;
   end Compute;

   procedure Compute (action : in Shot_Event_Prt; success : out Boolean) is
   begin
      if Utils.Compare_Coordinates(coord1 => Ball.Get_Position,
                                   coord2 => action.getFrom) then
         Ball.Set_Controlled(new_status => False);
         Ball.Set_Moving(new_status => True);

         ball_holder_id := 0;
         Motion_AgentPkg.Motion_Enabler.Move(source => action.getFrom,
                                             target => action.getTo,
                                             power  => action.Get_Shot_Power);
         success := True;
      else
         success := False;
      end if;
   end Compute;

   procedure Compute (action : in Tackle_Event_Prt; success : out Boolean) is
   begin
      Put_Line("Tackle_Event");
      if Utils.Compare_Coordinates(coord1 => action.getTo,
                                   coord2 => mStatus(action.Get_Other_Player_Id).mCoord) then
         -- Tento di rubargli la palla!
         if Calculate_Tackle(attacker_id   => action.getPlayer_Id,
                             ball_owner_id => action.Get_Other_Player_Id) then
            -- hell yeah! Mi prendo la palla
            ball.Move_Player(new_coord => action.getFrom);

            declare
               new_action : Motion_Event_Prt := new Motion_Event;
            begin
               new_action.Initialize(nPlayer_Id => 0,
                                     nFrom      => action.getTo,
                                     nTo        => action.getFrom);
               Buffer_Wrapper.Put(new_event => Core_Event.Event_Ptr (new_action));
               Buffer_Wrapper.Send;
               -- Da verificare!!!
            end;

            success := True;
         else
            -- oh no :-(
            success := False;
         end if;
      else
         success := False;
      end if;
   end Compute;

   procedure Compute (action : in Catch_Event_Prt; success : out Boolean) is
   begin
      Put_Line("Catch_event");
      Ball.Catch(player_coord => action.getTo,
                 succeded      => success);
      if success then
         ball_holder_id := action.getPlayer_Id;
      end if;
   end Compute;

   procedure Compute (action : in Motion_Event_Prt; success : out Boolean; revaluate : out Boolean) is
   begin
      success := False;
      revaluate := False;
      if action.all in Move_Event'Class then
         revaluate := True;
         Compute(action  => Move_Event_Prt(action),
                 success => success);
      elsif action.all in Shot_Event'Class then
         Compute(action  => Shot_Event_Prt(action),
                 success => success);
      elsif action.all in Tackle_Event'Class then
         Compute(action  => Tackle_Event_Prt(action),
                 success => success);
      elsif action.all in Catch_Event'Class then
         Compute(action  => Catch_Event_Prt(action),
                 success => success);
      end if;
   end Compute;

   task body Controller is
      mUtilityConstraint : Utility_Constraint := 6;
      compute_result : Boolean;
      revaluate : Boolean;
   begin
      Initialize;
      --Timer_Control.Start;

      -- Do la palla ad 1 all'inizio!!!
      ball_holder_id := 1;
      Ball.Set_Controlled(new_status => True);

      loop
         for Zone in Fields_Zone'Range loop
            select
               accept Write (mAction : in out Action) do
                  --                    Put("Action :");
                  --                    Put("- Player : " & I2S(mAction.event.getPlayer_Id));
                  --                    Put("- Cell target : " & I2S(mAction.event.getTo.coordX) & I2S(mAction.event.getTo.coordy));
                  --                    Put_Line("- Utility of the action : " & I2S(mAction.utility) & "/10");

                  -- Try to satisfy the request
                  Compute(mAction.event, compute_result, revaluate);

                  if not compute_result and revaluate then
                     -- Devo distinguere tra i tipi di mosse
                     Put_Line("===================================================================");
                     Put_Line("Sono " & I2S(mAction.event.getPlayer_Id) & " e sto per fare una requeue!!!!!!!!!!!");
                     Put_Line("===================================================================");
                     if(mAction.utility > mUtilityConstraint) then
                        mAction.utility := mAction.utility - 1;
                        requeue Awaiting(Occupy(mAction.event.getTo));
                     else
                        Put_Line("Mossa da rivedere");
                     end if;
                  end if;
               end Write;
            or
               when Released (Integer(Zone)) = True =>
                  accept Awaiting (Zone) (mAction : in out Action) do
                     Put_Line(I2S(Integer(Zone)) & " Sono ancora io perbacco! " & I2S(mAction.event.getPlayer_Id));

                     Compute(mAction.event, compute_result, revaluate);

                     if not compute_result and revaluate then
                        Put_Line("Giocatore " & I2S(mAction.event.getPlayer_Id) & " bloccato dal giocatore " & I2S(HereIsAPlayer(x => mAction.event.getTo.coordX,
                                                                                                                                 y => mAction.event.getTo.coordY)) & " alle coordinate " & I2S(mAction.event.getTo.coordX) & I2S(mAction.event.getTo.coordy));
                        if(mAction.utility > mUtilityConstraint) then
                           mAction.utility := mAction.utility - 1;
                           requeue Awaiting(Occupy(mAction.event.getTo));
                        else
                           Put_Line("Mossa da rivedere");
                        end if;
                     end if;
                  end Awaiting;
            end select;
         end loop;
      end loop;
   end Controller;

end Soccer.ControllerPkg;
