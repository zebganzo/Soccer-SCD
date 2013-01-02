with Soccer.Core_Event.Motion_Core_Event;

package Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event is

   type Shot_Motion_Event is new Motion_Event with private;
   type Shot_Motion_Event_Prt is access all Shot_Motion_Event;

   procedure Initialize (E : in out Shot_Motion_Event;
                         nPlayer_Id : in Integer;
                         nFrom : in Coordinate;
                         nTo : in Coordinate;
                         nShot_Power : Power_Range);

private

   type Shot_Motion_Event is new Motion_Event with
      record
         Shot_Power : Power_Range;
      end record;

end Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event;
