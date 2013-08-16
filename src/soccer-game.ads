with Soccer; use Soccer;
with Soccer.ControllerPkg; use Soccer.ControllerPkg;

package Soccer.Game is

   protected Game_Entity is
      entry Start;

      entry Start_1T;
      entry Rest;
      entry Start_2T;
      entry End_Match;

      procedure Notify;

   private

      open_1T : Boolean := False;
      open_2T : Boolean := False;

   end Game_Entity;

end Soccer.Game;
