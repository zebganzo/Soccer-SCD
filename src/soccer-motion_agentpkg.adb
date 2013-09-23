with Soccer.BallPkg;
use Soccer.BallPkg;

with Soccer.Utils;
use Soccer.Utils;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Motion_AgentPkg is

   actual_coord : Coordinate;
   actual_power : Power_Range;
   actual_target : Coordinate;
   real_target : Coordinate;
   start : Boolean := False;

   procedure Print (input : String) is
   begin
      if debug then
         pragma Debug (Put_Line (input));
         null;
      end if;
   end Print;


   protected body Motion_Enabler is
      procedure Move (source : Coordinate; target : Coordinate; power : Power_Range) is
      begin
--           Print("[MOTION_AGENT] Move");
         actual_coord := source;
         actual_power := power;
         real_target := target;
         start := True;
      end Move;

      procedure Stop is
      begin
         start := False;
      end Stop;

      entry Enabled when start is
      begin
         null;
      end Enabled;
   end Motion_Enabler;

   task body Motion_Agent is
   begin
      loop
         Motion_Enabler.Enabled;

         Print ("[MOTION_AGENT] Agente avviato");

         while start and actual_power > 0 and Ball.Get_Controlled = False loop
            Print("[MOTION_AGENT] Nuova coordinata " & Print_Coord (actual_coord));
            Ball.Set_Moving(new_status => True);
            actual_target := Utils.Get_Next_Coordinate(myCoord => actual_coord,
                                                       targetCoord => real_target);
            select
               Ball.Move_Agent(new_coord => actual_target);
               Print("[MOTION_AGENT] Palla mossa alla coordinata prestabilita");
               actual_coord := actual_target;
            else
               Print("[MOTION_AGENT] FIXME! Ramo else su -select-");
               exit;
            end select;

            delay duration (ball_speed);-- TODO:: Utils.Get_Ball_Delay(power => actual_power);
--              Print("[MOTION_AGENT] Delay scaduto, diminuisco la potenza");
--              actual_power := actual_power - 1;
--              Print("[MOTION_AGENT] Fine del ciclo" & " con actual_power = " & I2S(Integer(actual_power)) & " e Ball.Get_Controlled = "
--                       & Boolean'Image(Ball.Get_Controlled) & " " & Boolean'Image(actual_power > 0 and Ball.Get_Controlled = False));
         end loop;

         start := False;

         if actual_power = 0 then
            Print("[MOTION_AGENT] Potenza esaurita");
            null;
         end if;
         Ball.Set_Moving(new_status => False);
         Print("[MOTION_AGENT] Agente terminato");
      end loop;
   end Motion_Agent;

end Soccer.Motion_AgentPkg;
