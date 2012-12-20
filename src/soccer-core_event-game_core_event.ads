with Soccer.Core_Event;
use Soccer.Core_Event;

package Soccer.Core_Event.Game_Core_Event is

   type Game_Event  is abstract new Event with private;
   type Game_Event_Prt is access all Game_Event;

private

   type Game_Event is abstract new Event with record
      null;
   end record;

end Soccer.Core_Event.Game_Core_Event;
