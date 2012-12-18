with Soccer.Root_Event;
use Soccer.Root_Event;

package Soccer.Root_Event.Game_Root_Event is

   type Game_Event is new Event with private;
   type Game_Event_Prt is access all Game_Event;

   procedure Print (E : Game_Event);

private

   type Game_Event is new Event with record
      j : Integer := 20;
   end record;

end Soccer.Root_Event.Game_Root_Event;
