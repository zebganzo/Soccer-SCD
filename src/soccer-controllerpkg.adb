with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;

with Soccer.ControllerPkg.Referee;
use Soccer.ControllerPkg.Referee;

package body Soccer.ControllerPkg is

   type PlayerStatus is
      record
         running : Integer := 0;
         mcell : Cell := new CellType;
      end record;

   type Status is array (1 .. 1) of PlayerStatus;
   mStatus : Status;

   package Value_Functions is new Ada.Numerics.Generic_Elementary_Functions (Float);
   use Value_Functions;

   --+ Distanza tra due punti
   function distance(x1 : in Integer; x2 : in Integer; y1 : in Integer; y2 : in Integer) return Integer is
      dx, dy : float;
   begin
      dx := float(x1 - x2);
      dy := float(y1 - y2);
      return Integer(Sqrt( dx*dx + dy*dy ));
   end distance;

   --+ Ritorna la posizione in base all'id
   function getMyPosition(id : in Integer) return Cell is
   begin
      for i in mStatus'Range loop
         if(mStatus(i).mcell.id = id) then
            return mStatus(i).mcell;
         end if;
      end loop;
      return null;
   end getMyPosition;

   --+ Ritorna un Vector di Coordinate (id, x, y) dei giocatori di distanza <= a r
   function readStatus (x : in Integer; y : in Integer; r : in Integer) return ReadResult is
      result : ReadResult := new ReadResultType;
   begin
      for i in mStatus'Range loop
         if(distance(x1 => x,
                     x2 => mStatus(i).mcell.coordX,
                     y1 => y,
                     y2 => mStatus(i).mcell.coordY) <= r) then
            result.playersInMyZone.Append(New_Item => mStatus(i).mcell);
         end if;
      end loop;
      return result;
   end readStatus;

   --+ Controlla se in quella cella c'e' un giocatore
   function HereIsAPlayer(x : in Integer; y : in Integer) return Integer is
   begin
      for i in mStatus'Range loop
         if (mStatus(i).mcell.coordX = x and mStatus(i).mcell.coordY = y) then
            return mStatus(i).mcell.id;
         end if;
      end loop;
      return 0;
   end HereIsAPlayer;

   --+ Stampa del campo
   procedure PrintField is
   begin
      for i in  1 .. fieldMaxX + 1 loop
         Put("--");
      end loop;
      Put_Line("");
      for y in reverse 1 .. fieldMaxY loop
         Put("|");
         for x in 1 .. fieldMaxX loop
            Put(I2S(HereIsAPlayer(x => x, y => y)));
         end loop;
         Put("|");
         Put_Line("");
      end loop;
      for i in  1 .. fieldMaxX + 1 loop
         Put("--");
      end loop;
      Put_Line("");
   end PrintField;

   task body Controller is
      mUtilityConstraint : utilityConstraint := 6;
   begin
      -- Init dello stato in modo casuale
      for i in mStatus'Range loop
         mStatus(i).mcell.id := i;
         mStatus(i).mcell.coordX := i*4;
         mStatus(i).mcell.coordY := i*6;
      end loop;

      loop
         select
            accept Write(mAction : in Action) do
               Put_Line("Action :");
               Put_Line("- Player : " & I2S(mAction.byWho));
               Put_Line("- Cell target : " & I2S(mAction.cellTarget.coordX) & I2S(mAction.cellTarget.coordY));
               Put_Line("- Utility of the action : " & I2S(mAction.utility) & "/10");

               if(HereIsAPlayer(x => mAction.cellTarget.coordX,
                                y => mAction.cellTarget.coordY) = 0) then
                  -- Rilascio la cella da cui parto
                  mStatus(mAction.byWho).mcell.coordX := mAction.cellTarget.coordX;
                  mStatus(mAction.byWho).mcell.coordY := mAction.cellTarget.coordY;
               else
                  if(mAction.utility > mUtilityConstraint) then
                     -- A volte vale la pena di aspettare...
                     requeue Awaiting;
                  else
                     -- ...altre no!
                     Put_Line("Rivedere la mossa!");
                  end if;
               end if;
            end Write;
         or
            accept Awaiting (mAction : in Action) do
               Put_Line("Sono ancora io perbacco!");
            end Awaiting;
         end select;
      end loop;
   end Controller;

end Soccer.ControllerPkg;
