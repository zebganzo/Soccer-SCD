with Soccer.ControllerPkg, Soccer.PlayersPkg;
use Soccer.ControllerPkg, Soccer.PlayersPkg;

with Soccer.Bridge;
use Soccer.Bridge;


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
--     ThreeCoord : Coordinate_Ptr := new Coordinate'(coordX => 12,
--                                                    coordY => 3);
--     FourCoord : Coordinate_Ptr := new Coordinate'(coordX => 12,
--                                                    coordY => 3);
--     FiveCoord : Coordinate_Ptr := new Coordinate'(coordX => 12,
--                                                    coordY => 3);
--     SixCoord : Coordinate_Ptr := new Coordinate'(coordX => 12,
--                                          coordY => 3);
   One   : Player (Id    => 1, Ability => 4, Initial_Coord => OneCoord);
   Two   : Player (Id    => 2, Ability => 2, Initial_Coord => TwoCoord);
--     Three : Player (Id    => 3, Ability => 5, Initial_Coord => ThreeCoord);
--     Four : Player (Id    => 4, Ability => 6, Initial_Coord => FourCoord);
--     Five : Player (Id    => 5, Ability => 4, Initial_Coord => FiveCoord);
--     Six : Player (Id    => 6, Ability => 3, Initial_Coord => SixCoord);
begin
   null;
end Soccer.Main;

