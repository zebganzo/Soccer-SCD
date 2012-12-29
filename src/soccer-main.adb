with Soccer.PlayersPkg;
use Soccer.PlayersPkg;

with Soccer.ControllerPkg;

with Soccer.BallPkg;
with Soccer.Motion_AgentPkg;

with Soccer.Bridge.Output;
use Soccer.Bridge.Output;

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
   One   : Player (Id    => 1, Ability => 4, Initial_Coord_X => 5, Initial_Coord_Y => 5);
   Two   : Player (Id    => 2, Ability => 2, Initial_Coord_X => 14, Initial_Coord_Y => 9);
   Three : Player (Id    => 3, Ability => 5, Initial_Coord_X => 12, Initial_Coord_Y => 3);
   Four : Player (Id    => 4, Ability => 6, Initial_Coord_X => 10, Initial_Coord_Y => 7);
   Five : Player (Id    => 5, Ability => 4, Initial_Coord_X => 2, Initial_Coord_Y => 3);
   Six : Player (Id    => 6, Ability => 3, Initial_Coord_X => 3, Initial_Coord_Y => 9);
   Seven : Player (Id    => 7, Ability => 3, Initial_Coord_X => 1, Initial_Coord_Y => 6);
begin

   Soccer.Server.WebServer.Start;

--     delay 10.0;
--     Soccer.Server.WebServer.PublishFieldUpdate;

end Soccer.Main;

