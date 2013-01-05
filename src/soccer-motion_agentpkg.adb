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

   protected body Motion_Enabler is
      procedure Move (source : Coordinate; target : Coordinate; power : Power_Range) is
      begin
         Put_Line("Move on Agent");
         actual_coord := source;
         actual_power := power;
         real_target := target;
         start := True;
      end Move;

      entry Enabled when start is
      begin
         null;
      end Enabled;
   end Motion_Enabler;

   task body Motion_Agent is
   begin
      loop
         Motion_Enabler.Enabled;

         Put_Line("Motion_Agent in azione!!!!!!!!!!");

         while actual_power > 0 and Ball.Get_Controlled = False loop
            Put_Line("New Ball Coords " & I2S(actual_coord.coordX) & " " & I2S(actual_coord.coordY));
            Ball.Set_Moving(new_status => True);
            actual_target := Utils.Get_Next_Coordinate(myCoord => actual_coord,
                                                       targetCoord => real_target);
            select
               Ball.Move_Agent(new_coord => actual_target);
               Put_Line ("after move agent call");
               actual_coord := actual_target;
            else
               Put_Line("Ramo else della select!!!");
               exit;
            end select;

            delay 1.0;-- Utils.Get_Ball_Delay(power => actual_power);
            Put_Line ("after dealy");
            actual_power := actual_power - 1;
            Put_Line("Fine while!!!!" & " actual_power " & I2S(Integer(actual_power)) & " Ball.Get_Controlled = "
                     & Boolean'Image(Ball.Get_Controlled) & " " & Boolean'Image(actual_power > 0 and Ball.Get_Controlled = False));
         end loop;

         start := False;

         if actual_power = 0 then
            Put_Line("Aiaiaiai...e' finita la potenza amico!!!");
         end if;
         Ball.Set_Moving(new_status => False);
         Put_Line("Move Finitiaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      end loop;
   end Motion_Agent;

end Soccer.Motion_AgentPkg;
