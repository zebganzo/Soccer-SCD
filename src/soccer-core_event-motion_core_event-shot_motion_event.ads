with Soccer.Core_Event.Motion_Core_Event;

package Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event is

   type Shot_Event is new Motion_Event with private;
   type Shot_Event_Ptr is access all Shot_Event;

   procedure Set_Shot_Power (E : in out Shot_Event; power : Power_Range);

   function Get_Shot_Power (E : in Shot_Event) return Power_Range;

private

   type Shot_Event is new Motion_Event with
      record
         Shot_Power : Power_Range;
      end record;

end Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event;
