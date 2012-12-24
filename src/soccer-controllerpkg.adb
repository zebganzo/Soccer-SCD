with Ada.Text_IO; use Ada.Text_IO;

with Soccer.Utils;
use Soccer.Utils;

with Soccer.ControllerPkg.Referee;
use Soccer.ControllerPkg.Referee;

with Ada.Numerics.Generic_Elementary_Functions;

package body Soccer.ControllerPkg is

   type Status is array (1 .. Num_Of_Player) of PlayerStatus;
   mStatus : Status;

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
         if(distance(x1 => x,
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

   task body Controller is
      Released : Boolean := False;
      mUtilityConstraint : utilityConstraint := 6;
   begin
      Initialize;
      loop
         select
            when True =>
               accept Write(mAction : in Action) do
                  Put("Action :");
                  Put("- Player : " & I2S(mAction.event.getPlayer_Id));
                  Put("- Cell target : " & I2S(mAction.event.getTo.coordX) & I2S(mAction.event.getTo.coordy));
                  Put_Line("- Utility of the action : " & I2S(mAction.utility) & "/10");

                  -- Try to satisfy the request
                  if(HereIsAPlayer(x => mAction.event.getTo.coordX,
                                   y => mAction.event.getTo.coordY) = 0) then
                     -- Free position
                     mStatus(mAction.event.getPlayer_Id).mCoord := mAction.event.getTo;
                     Released := True;
                  else
                     Released := False;
                     requeue Awaiting;
                  end if;
               end Write;
         or
            when Released =>
               accept Awaiting (mAction : in Action) do
                  Put_Line("Sono ancora io perbacco! " & I2S(mAction.event.getPlayer_Id));
                  if(HereIsAPlayer(x => mAction.event.getTo.coordX,
                                   y => mAction.event.getTo.coordY) = 0) then
                     mStatus(mAction.event.getPlayer_Id).mCoord := mAction.event.getTo;
                     Released := True;
                  else
                     Released := False;
                     requeue Awaiting;
                  end if;
               end Awaiting;
         end select;
      end loop;
   end Controller;

end Soccer.ControllerPkg;
