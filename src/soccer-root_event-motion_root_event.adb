with Soccer.Root_Event.Motion_Root_Event;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Root_Event.Motion_Root_Event is

   procedure Print (E : Motion_Event) is
   begin
      Put_Line("motion event");
   end Print;

end Soccer.Root_Event.Motion_Root_Event;
