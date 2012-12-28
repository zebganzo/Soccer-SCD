with Soccer.PlayersPkg;
use Soccer.PlayersPkg;

with Soccer.ControllerPkg;
use Soccer.ControllerPkg;

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

   OneCoord : Coordinate_Ptr := new Coordinate'(coordX => 5,
                                                coordY => 5);
   TwoCoord : Coordinate_Ptr := new Coordinate'(coordX => 14,
                                                coordY => 9);
   ThreeCoord : Coordinate_Ptr := new Coordinate'(coordX => 12,
                                                  coordY => 3);
   FourCoord : Coordinate_Ptr := new Coordinate'(coordX => 10,
                                                 coordY => 7);
   FiveCoord : Coordinate_Ptr := new Coordinate'(coordX => 2,
                                                 coordY => 3);
   SixCoord : Coordinate_Ptr := new Coordinate'(coordX => 3,
                                                coordY => 9);
   SevenCoord : Coordinate_Ptr := new Coordinate'(coordX => 1,
                                                  coordY => 6);
   One   : Player (Id    => 1, Ability => 4, Initial_Coord => OneCoord);
   Two   : Player (Id    => 2, Ability => 2, Initial_Coord => TwoCoord);
   Three : Player (Id    => 3, Ability => 5, Initial_Coord => ThreeCoord);
   Four : Player (Id    => 4, Ability => 6, Initial_Coord => FourCoord);
   Five : Player (Id    => 5, Ability => 4, Initial_Coord => FiveCoord);
   Six : Player (Id    => 6, Ability => 3, Initial_Coord => SixCoord);
   Seven : Player (Id    => 7, Ability => 3, Initial_Coord => SevenCoord);
begin

   Soccer.Server.WebServer.Start;

--     delay 10.0;
--     Soccer.Server.WebServer.PublishFieldUpdate;

end Soccer.Main;

