with Soccer.Core_Event.Game_Core_Event;
use Soccer.Core_Event.Game_Core_Event;

package Soccer.Core_Event.Game_Core_Event.Binary_Game_Event is

   type Binary_Event is new Event with private;
   type Binary_Event_Prt is access all Binary_Event;

   procedure Serialize (E : Binary_Event; Serialized_Obj : out JSON_Value);

   type Binary_Event_Id is (Substitution, Foul);

private

   type Binary_Event is new Game_Event with record
      Event_Id : Binary_Event_Id;
      Player_Id_1 : Integer;
      Player_Id_2 : Integer;
   end record;

end Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
