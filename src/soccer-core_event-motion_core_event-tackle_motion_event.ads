with Soccer.Core_Event.Motion_Core_Event;

package Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event is

   type Tackle_Event is new Motion_Event with private;
   type Tackle_Event_Prt is access all Tackle_Event;

   procedure Initialize (E : in out Tackle_Event;
                         nPlayer_Id : in Integer;
                         nFrom : in Coordinate;
                         nTo : in Coordinate);

   procedure Set_Other_Player_Id (E : in out Tackle_Event; id : in Integer);

   function Get_Other_Player_Id (E : in Tackle_Event) return Integer;

private

   type Tackle_Event is new Motion_Event with
      record
	Other_Player_Id : Integer;
      end record;

end Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;
