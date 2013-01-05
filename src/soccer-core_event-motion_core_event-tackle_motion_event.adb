with Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;

package body Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event is

   function getOther_Player_Id (E : in Tackle_Event) return Integer is
   begin
      return E.Other_Player_Id;
   end getOther_Player_Id;

   procedure Initialize (E : in out Tackle_Event;
                         nPlayer_Id : in Integer;
                         nFrom : in Coordinate;
                         nTo : in Coordinate;
                         nOther_Player_Id : Integer) is
   begin
      E.Player_Id := nPlayer_Id;
      E.From := nFrom;
      E.To := nTo; -- nil
      E.Other_Player_Id := nOther_Player_Id;
   end Initialize;

end Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;
