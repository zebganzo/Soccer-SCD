--with Soccer.ControllerPkg, Soccer.PlayersPkg;
--use Soccer.ControllerPkg, Soccer.PlayersPkg;

with Soccer.Bridge;
use Soccer.Bridge;

with Soccer.Server;
with Soccer.Server.WebServer;

with Ada.Text_IO; use Ada.Text_IO;
with Soccer.Core_Event.Game_Core_Event.Binary_Game_Event; use Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
with Soccer.Core_Event.Game_Core_Event.Unary_Game_Event; use Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
with Soccer.Core_Event.Game_Core_Event.Match_Game_Event; use Soccer.Core_Event.Game_Core_Event.Match_Game_Event;
with Soccer.Core_Event; use Soccer.Core_Event;



procedure Soccer.Main is

   type EventArray is array (1 .. 3) of Event_Ptr;

   arr : EventArray;

   --One   : Player (Id    => 1, Ability => 4);
   --Two   : Player (Id    => 2, Ability => 2);
   --Three : Player (Id    => 3, Ability => 5);
begin

   arr(1) := new Binary_Event;
   arr(2) := new Unary_Event;
   arr(3) := new Match_Event;

   Soccer.Server.WebServer.Start;

--     delay 10.0;
--     Soccer.Server.WebServer.PublishFieldUpdate;

   --Core_Event.Print(E => arr(1).all);
   --Core_Event.Print(E => arr(2).all);
   --Core_Event.Print(E => arr(3).all);

--     loop
--        delay duration (1);
--        ControllerPkg.PrintField;
--     end loop;
   Put_Line("prima");
   -- Soccer.Bridge.Input.PutStuff;
   Put_Line("dopo");
end Soccer.Main;

