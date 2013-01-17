with Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;

package body Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event is

   procedure Update_To_Coordinate (E : in out Move_Event; new_coord : in Coordinate) is
   begin
      E.To := new_coord;
   end Update_To_Coordinate;


end Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;
