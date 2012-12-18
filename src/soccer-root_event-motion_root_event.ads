with Soccer.Root_Event;
use Soccer.Root_Event;

package Soccer.Root_Event.Motion_Root_Event is

   type Motion_Event is new Event with private;
   type Motion_Event_Prt is access all Motion_Event;

   procedure Print (E : Motion_Event);

private

   type Motion_Event is new Event with record
      j : Integer := 20;
   end record;

end Soccer.Root_Event.Motion_Root_Event;
