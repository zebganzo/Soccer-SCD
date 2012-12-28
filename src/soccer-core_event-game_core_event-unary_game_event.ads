with Soccer.Core_Event.Game_Core_Event;
use Soccer.Core_Event.Game_Core_Event;

package Soccer.Core_Event.Game_Core_Event.Unary_Game_Event is

   type Unary_Event is new Event with private;
   type Unary_Event_Prt is access all Unary_Event;
   type Unary_Event_Id is (SendOff, Booking, Goal, Injuring);

   procedure Serialize (E : Unary_Event; Serialized_Obj : out JSON_Value);

   procedure Initialize (E : in out Unary_Event; nEvent_Id : in Unary_Event_Id; nPlayer_Id : in Integer);

private

   type Unary_Event is new Game_Event with record
      Event_Id : Unary_Event_Id;
      Player_Id : Integer;
   end record;

end Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
