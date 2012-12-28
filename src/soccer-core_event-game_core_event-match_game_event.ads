with Soccer.Core_Event.Game_Core_Event;
use Soccer.Core_Event.Game_Core_Event;

package Soccer.Core_Event.Game_Core_Event.Match_Game_Event is

   type Match_Event is new Event with private;
   type Match_Event_Prt is access all Match_Event;

   type Match_Event_Id is (Begin_Of_Match, End_Of_First_Half, Beginning_Of_Second_Half, End_Of_Match);

   procedure Serialize (E : Match_Event; Serialized_Obj : out JSON_Value);

   procedure Initialize (E : in out Match_Event; nEvent_Id : in Match_Event_Id);

private

   type Match_Event is new Game_Event with record
      Event_Id : Match_Event_Id;
   end record;

end Soccer.Core_Event.Game_Core_Event.Match_Game_Event;
