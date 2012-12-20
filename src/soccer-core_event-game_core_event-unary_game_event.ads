with Soccer.Core_Event.Game_Core_Event;
use Soccer.Core_Event.Game_Core_Event;

package Soccer.Core_Event.Game_Core_Event.Unary_Game_Event is

   type Unary_Event is new Event with private;
   type Unary_Event_Prt is access all Unary_Event;

   procedure Serialize (E : Unary_Event; Serialized_Obj : out JSON_Value);

   type Unary_Event_Id is (SendOff, Booking, Goal, Injuring);

private

   type Unary_Event is new Game_Event with record
      Event_Id : Unary_Event_Id;
      Player_Id : Integer;
   end record;

end Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
