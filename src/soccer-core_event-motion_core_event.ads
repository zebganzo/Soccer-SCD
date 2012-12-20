with Soccer.Core_Event;
use Soccer.Core_Event;

package Soccer.Core_Event.Motion_Core_Event is

   type Motion_Event is new Event with private;
   type Motion_Event_Prt is access all Motion_Event;

   procedure Serialize (E : Motion_Event; Serialized_Obj : out JSON_Value);

private

   type Motion_Event is new Event with record
      Player_Id : Integer;
      From : Coordinate;
      To : Coordinate;
   end record;

end Soccer.Core_Event.Motion_Core_Event;
