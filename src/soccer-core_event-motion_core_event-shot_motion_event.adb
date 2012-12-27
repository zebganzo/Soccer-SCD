with Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event;

package body Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event is

   procedure Initialize (E : in out Shot_Motion_Event;
                         nPlayer_Id : in Integer;
                         nFrom : in Coordinate;
                         nTo : in Coordinate;
                         nShot_Power : rangePower) is
   begin
      E.Player_Id := nPlayer_Id;
      E.From := nFrom;
      E.To := nTo; -- nil
      E.Shot_Power := nShot_Power;
   end Initialize;

end Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event;
