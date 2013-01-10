with Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;

package body Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event is

   function Get_Other_Player_Id (E : in Tackle_Event) return Integer is
   begin
      return E.Other_Player_Id;
   end Get_Other_Player_Id;

   procedure Initialize (E : in out Tackle_Event;
                         nPlayer_Id : in Integer;
                         nFrom : in Coordinate;
                         nTo : in Coordinate) is
   begin
      E.Player_Id := nPlayer_Id;
      E.From := nFrom;
      E.To := nTo;
   end Initialize;

   procedure Set_Other_Player_Id (E : in out Tackle_Event; id : in Integer) is
   begin
      E.Other_Player_Id := id;
   end Set_Other_Player_Id;

end Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;
