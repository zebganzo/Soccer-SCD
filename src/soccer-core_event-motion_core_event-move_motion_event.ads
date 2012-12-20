with Soccer.Core_Event.Motion_Core_Event;

package Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event is

   type Move_Event is new Motion_Event with private;
   type Move_Event_Prt is access all Move_Event;

private

   type Move_Event is new Motion_Event with null record;

end Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;
