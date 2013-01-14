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
with Soccer.TeamPkg; use Soccer.TeamPkg;



procedure Soccer.Main is

--     OneCoord : Coordinate_Ptr := new Coordinate'(coordX => 5,
--                                                  coordY => 5);
--     TwoCoord : Coordinate_Ptr := new Coordinate'(coordX => 14,
--                                                  coordY => 9);
--     ThreeCoord : Coordinate_Ptr := new Coordinate'(coordX => 12,
--                                                    coordY => 3);
--     FourCoord : Coordinate_Ptr := new Coordinate'(coordX => 10,
--                                                   coordY => 7);
--     FiveCoord : Coordinate_Ptr := new Coordinate'(coordX => 2,
--                                                   coordY => 3);
--     SixCoord : Coordinate_Ptr := new Coordinate'(coordX => 3,
--                                                  coordY => 9);
--     SevenCoord : Coordinate_Ptr := new Coordinate'(coordX => 1,
--                                                    coordY => 6);
   One   : Player (Id    => 1, Ability => 20, Initial_Coord_X => 5, Initial_Coord_Y => 5, Team => Team_One);
   Two   : Player (Id    => 2, Ability => 15, Initial_Coord_X => 25, Initial_Coord_Y => 13, Team => Team_One);
   Three : Player (Id    => 3, Ability => 17, Initial_Coord_X => 17, Initial_Coord_Y => 9, Team => Team_One);
   Four : Player (Id    => 4, Ability => 18, Initial_Coord_X => 10, Initial_Coord_Y => 18, Team => Team_Two);
   Five : Player (Id    => 5, Ability => 12, Initial_Coord_X => 28, Initial_Coord_Y => 2, Team => Team_Two);
   Six : Player (Id    => 6, Ability => 24, Initial_Coord_X => 6, Initial_Coord_Y => 6, Team => Team_Two);
   Seven : Player (Id    => 7, Ability => 13, Initial_Coord_X => 14, Initial_Coord_Y => 15, Team => Team_Two);
begin

   null;

--     Soccer.Server.WebServer.Start;

--     delay 10.0;
--     Soccer.Server.WebServer.PublishFieldUpdate;

end Soccer.Main;

