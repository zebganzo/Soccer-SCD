with Ada.Text_IO;
use Ada.Text_IO;

with Ada.Numerics;
with Ada.Numerics.Discrete_Random;

with Soccer.TeamPkg; use Soccer.TeamPkg;
with Soccer.Game; use Soccer.Game;

with Soccer.ControllerPkg;
use Soccer.ControllerPkg;

with Soccer.Utils;
use Soccer.Utils;

with Soccer.Core_Event.Motion_Core_Event.Catch_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Catch_Motion_Event;
with Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;
with Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event;
with Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;

with Soccer.Core_Event.Game_Core_Event; use Soccer.Core_Event.Game_Core_Event;
with Soccer.Core_Event.Game_Core_Event.Unary_Game_Event; use Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
with Soccer.Core_Event.Game_Core_Event.Match_Game_Event; use Soccer.Core_Event.Game_Core_Event.Match_Game_Event;

with Soccer.BallPkg; use Soccer.BallPkg;

use Soccer.Core_Event.Motion_Core_Event;

package Soccer.PlayersPkg is

   -- Il package Players contiene il task Player...non credo vi sia bisogno di descriverlo

   -- Entità attiva    : Player
   task type Player (ability : Integer; initial_coord_x : Positive; initial_coord_y : Positive; team : Team_Id);

end Soccer.PlayersPkg;
