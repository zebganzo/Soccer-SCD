with Soccer.BallPkg;
use Soccer.BallPkg;

with Soccer.Utils;
use Soccer.Utils;
with Ada.Text_IO; use Ada.Text_IO;
with Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event; use Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;
with Soccer.Core_Event.Motion_Core_Event; use Soccer.Core_Event.Motion_Core_Event;
with Soccer.Bridge.Output; use Soccer.Bridge.Output;
with Soccer.TeamPkg; use Soccer.TeamPkg;

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
         Print("[MOTION_AGENT] Move");

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
      t_ma_start : Time;
      t_ma_end : Time;
   begin
      loop
         Motion_Enabler.Enabled;

         Print ("[MOTION_AGENT] Agente avviato");

	 declare
	    starting_coord : Coordinate;
	    new_event : Motion_Event_Ptr;
	 begin
	    while start
	      and actual_power > 0
	      and Ball.Get_Controlled = False
	      and not Compare_Coordinates (Ball.Get_Position, real_target) loop

	       t_ma_start := Clock;

	       starting_coord := Ball.Get_Position;

	       Print ("[MOTION_AGENT] Nuova coordinata " & Print_Coord (actual_coord));
	       Ball.Set_Moving(new_status => True);
	       actual_target := Get_Next_Coordinate(actual_coord,
					     real_target);
	       select
		  Ball.Move_Agent(new_coord => actual_target);
		  Print ("[MOTION_AGENT] Palla mossa alla coordinata prestabilita");
		  actual_coord := actual_target;

		  -- manda l'evento alla distribuzione
		  new_event := new Move_Event;
		  new_event.Initialize (0, 0, Team_One, starting_coord, actual_coord);
		  Buffer_Wrapper.Put (Core_Event.Event_Ptr (new_event));
	       else
		  Print ("[MOTION_AGENT] FIXME! Ramo else su -select-");
		  exit;
	       end select;

	       t_ma_end := Clock;

	       Print ("[MOTION_AGENT] MOTION TIME: " & Duration'Image (t_ma_end - t_ma_start));

	       delay duration (ball_speed);-- TODO:: Utils.Get_Ball_Delay(power => actual_power);
	       --              Print("[MOTION_AGENT] Delay scaduto, diminuisco la potenza");
	       --                  actual_power := actual_power - 1;
	       --              Print("[MOTION_AGENT] Fine del ciclo" & " con actual_power = " & I2S(Integer(actual_power)) & " e Ball.Get_Controlled = "
	       --                       & Boolean'Image(Ball.Get_Controlled) & " " & Boolean'Image(actual_power > 0 and Ball.Get_Controlled = False));
	    end loop;
	 end;


         start := False;

         if actual_power = 0 then
            Print ("[MOTION_AGENT] Potenza esaurita");
            null;
	 end if;

         Ball.Set_Moving(new_status => False);
	 Print ("[MOTION_AGENT] Agente terminato");

      end loop;
   end Motion_Agent;

end Soccer.Motion_AgentPkg;
