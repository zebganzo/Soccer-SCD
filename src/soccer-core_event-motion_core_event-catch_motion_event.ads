with Soccer.Core_Event.Motion_Core_Event;

package Soccer.Core_Event.Motion_Core_Event.Catch_Motion_Event is

   type Catch_Motion_Event is new Motion_Event with private;
   type Catch_Motion_Event_Prt is access all Catch_Motion_Event;

private

   type Catch_Motion_Event is new Motion_Event with null record;

end Soccer.Core_Event.Motion_Core_Event.Catch_Motion_Event;
