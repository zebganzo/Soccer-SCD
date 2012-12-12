with Soccer.ControllerPkg, Soccer.PlayersPkg;
use Soccer.ControllerPkg, Soccer.PlayersPkg;
with Ada.Text_IO; use Ada.Text_IO;

procedure Soccer.Main is

   One   : Player (Id    => 1, Ability => 4);
   --Two   : Player (Id    => 2, Ability => 2);
   --Three : Player (Id    => 3, Ability => 5);
begin
   loop
      delay duration (1);
      ControllerPkg.PrintField;
   end loop;
end Soccer.Main;

