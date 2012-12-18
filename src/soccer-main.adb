--with Soccer.ControllerPkg, Soccer.PlayersPkg;
--use Soccer.ControllerPkg, Soccer.PlayersPkg;

with Soccer.Root_Event; use Soccer.Root_Event;
with Soccer.Root_Event.Motion_Root_Event; use Soccer.Root_Event.Motion_Root_Event;
with Soccer.Root_Event.Game_Root_Event; use Soccer.Root_Event.Game_Root_Event;

with Soccer.Bridge;

with Ada.Text_IO; use Ada.Text_IO;

procedure Soccer.Main is

   type EventArray is array (1 .. 3) of Event_Ptr;

   arr : EventArray;

   --One   : Player (Id    => 1, Ability => 4);
   --Two   : Player (Id    => 2, Ability => 2);
   --Three : Player (Id    => 3, Ability => 5);
begin

   arr(1) := new Motion_Event;
   arr(2) := new Game_Event;
   arr(3) := new Motion_Event;

   Root_Event.Print(E => arr(1).all);
   Root_Event.Print(E => arr(2).all);
   Root_Event.Print(E => arr(3).all);

--     loop
--        delay duration (1);
--        ControllerPkg.PrintField;
--     end loop;
   Put_Line("prima");
   -- Soccer.Bridge.Input.PutStuff;
   Put_Line("dopo");
end Soccer.Main;

