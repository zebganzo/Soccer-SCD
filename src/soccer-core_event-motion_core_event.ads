with Soccer.Core_Event;
use Soccer.Core_Event;

package Soccer.Core_Event.Motion_Core_Event is

   type Motion_Event is abstract new Event with private;
   type Motion_Event_Prt is access all Motion_Event;

private

   type Motion_Event is abstract new Event with record
      null;
   end record;

end Soccer.Core_Event.Motion_Core_Event;
