with GNATCOLL.JSON;
use GNATCOLL.JSON;

with Soccer.Manager_Event;
use Soccer.Manager_Event;
with Soccer.Manager_Event.Substitution;
with Soccer.Manager_Event.Formation;

with Soccer.Field_Event;
use Soccer.Field_Event;

with Soccer.Core_Event;
use Soccer.Core_Event;
with Soccer.Core_Event.Motion_Core_Event;
with Soccer.Core_Event.Motion_Core_Event.Catch_Motion_Event;
with Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;
with Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event;
with Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;
with Soccer.Core_Event.Game_Core_Event;
with Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
with Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
with Soccer.Core_Event.Game_Core_Event.Match_Game_Event;

package Soccer.Bridge is

--     type EventArray is array (1 .. 3) of Event_Ptr;

   procedure Print_All (E : Soccer.Core_Event.Event_Ptr);

end Soccer.Bridge;
