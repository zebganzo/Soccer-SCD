with Soccer.Core_Event.Motion_Core_Event;

package Soccer.Core_Event.Motion_Core_Event.Catch_Motion_Event is

   type Catch_Event is new Motion_Event with private;
   type Catch_Event_Ptr is access all Catch_Event'Class;

private

   type Catch_Event is new Motion_Event with null record;

end Soccer.Core_Event.Motion_Core_Event.Catch_Motion_Event;
