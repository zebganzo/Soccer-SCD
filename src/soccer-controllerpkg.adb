with Ada.Text_IO; use Ada.Text_IO;

with Soccer.Utils;
use Soccer.Utils;

--  with Soccer.ControllerPkg.Referee;
--  use Soccer.ControllerPkg.Referee;

with Ada.Numerics.Generic_Elementary_Functions;
with Soccer.Bridge.Output; use Soccer.Bridge.Output;
with Soccer.Manager_Event; use Soccer.Manager_Event;

package body Soccer.ControllerPkg is

   type Status is array (1 .. Num_Of_Player) of PlayerStatus;
   mStatus : Status;

   type Released_Zone is array (1 .. Num_Of_Zone) of Boolean;

   --+ Ritorna la posizione in base all'id
   function getMyPosition(id : in Integer) return Coordinate is
      result : Coordinate;
   begin
      for i in mStatus'Range loop
         if(mStatus(i).id = id) then
            result := mStatus(i).mCoord;
            exit;
         end if;
      end loop;
      return result;
   end getMyPosition;

   --+ Ritorna un Vector di Coordinate (id, x, y) dei giocatori di distanza <= a r
   function readStatus (x : in Integer; y : in Integer; r : in Integer) return ReadResult is
      result : ReadResult := new ReadResultType;
   begin
      for i in mStatus'Range loop
         if(Distance(x1 => x,
                     x2 => mStatus(i).mCoord.coordX,
                     y1 => y,
                     y2 => mStatus(i).mCoord.coordY) <= r) then
            result.playersInMyZone.Append(New_Item => mStatus(i));
         end if;
      end loop;
      return result;
   end readStatus;

   --+ Controlla se in quella cella c'e' un giocatore
   function HereIsAPlayer(x : in Integer; y : in Integer) return Integer is
   begin
      for i in mStatus'Range loop
         if (mStatus(i).mCoord.coordX = x and mStatus(i).mCoord.coordY = y) then
            return mStatus(i).id;
         end if;
      end loop;
      return 0;
   end HereIsAPlayer;

   --+ Inizializza l'array Status con l'id di ogni giocatore
   procedure Initialize is
   begin
      for i in 1 .. Num_Of_Player loop
         mStatus(i).id := i;
      end loop;
   end Initialize;

   --+ Stampa del campo
   procedure PrintField is
   begin
      for i in  1 .. Field_Max_X + 1 loop
         Put("--");
      end loop;
      Put_Line("");
      for y in reverse 1 .. Field_Max_Y loop
         Put("|");
         for x in 1 .. Field_Max_X loop
            Put(I2S(HereIsAPlayer(x => x, y => y)));
         end loop;
         Put("|");
         Put_Line("");
      end loop;
      for i in  1 .. Field_Max_X + 1 loop
         Put("--");
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

   task body Controller is
      mUtilityConstraint : Utility_Constraint := 6;
      event_pointer : Core_Event.Event_Ptr;
   begin
      Initialize;
      loop
         for Zone in Fields_Zone'Range loop
            select
               accept Write (mAction : in out Action) do
                  Put("Action :");
                  Put("- Player : " & I2S(mAction.event.getPlayer_Id));
                  Put("- Cell target : " & I2S(mAction.event.getTo.coordX) & I2S(mAction.event.getTo.coordy));
                  Put_Line("- Utility of the action : " & I2S(mAction.utility) & "/10");

                  -- Try to satisfy the request
                  if(HereIsAPlayer(x => mAction.event.getTo.coordX,
                                   y => mAction.event.getTo.coordY) = 0) then
                     -- Free position
		     mStatus(mAction.event.getPlayer_Id).mCoord := mAction.event.getTo;
		     event_pointer := Core_Event.Event_Ptr (mAction.event);
		     Buffer_Wrapper.Put (new_event => event_pointer);
                     Release(mAction.event.getFrom);
                  else
                     Put_Line("Giocatore " & I2S(mAction.event.getPlayer_Id) & " bloccato dal giocatore " & I2S(HereIsAPlayer(x => mAction.event.getTo.coordX,
                                                                                                                              y => mAction.event.getTo.coordY)) & " alle coordinate " & I2S(mAction.event.getTo.coordX) & I2S(mAction.event.getTo.coordy));
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
                     if(HereIsAPlayer(x => mAction.event.getTo.coordX,
                                      y => mAction.event.getTo.coordY) = 0) then
			mStatus(mAction.event.getPlayer_Id).mCoord := mAction.event.getTo;
			event_pointer := Core_Event.Event_Ptr (mAction.event);
			Buffer_Wrapper.Put (new_event => event_pointer);
                        Release(mAction.event.getFrom);
                     else
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
