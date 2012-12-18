with Soccer.Root_Event.Game_Root_Event;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Root_Event.Game_Root_Event is

   procedure Print (E : Game_Event) is
   begin
      Put_Line("game event");
   end Print;

end Soccer.Root_Event.Game_Root_Event;
