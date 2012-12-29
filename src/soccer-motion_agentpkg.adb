with Soccer.BallPkg;
use Soccer.BallPkg;

with Soccer.Utils;
use Soccer.Utils;

package body Soccer.Motion_AgentPkg is

   task body Motion_Agent is
      actual_coord : Coordinate;
      actual_power : Power_Range;
   begin
      loop
         select
            accept Move (source : Coordinate; target : Coordinate; power : Power_Range) do
               actual_coord := source;
               actual_power := power;
               while power > 0 and Ball.Get_Controlled = False loop
                  Ball.Set_Moving(new_status => True);
                  select
                     Ball.Move_Agent(new_coord => Utils.Get_Next_Coordinate(myCoord => actual_coord,
                                                                            targetCoord => target));
                  else
                     exit;
                  end select;
                  delay Utils.Get_Ball_Delay(power => actual_power);
                  actual_power := actual_power - 1;
               end loop;
               Ball.Set_Moving(new_status => False);
            end Move;
         end select;
      end loop;
   end Motion_Agent;

end Soccer.Motion_AgentPkg;
