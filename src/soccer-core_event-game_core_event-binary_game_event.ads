with Soccer.Core_Event.Game_Core_Event;
use Soccer.Core_Event.Game_Core_Event;

package Soccer.Core_Event.Game_Core_Event.Binary_Game_Event is

   type Binary_Event is new Event with private;
   type Binary_Event_Prt is access all Binary_Event;

   type Binary_Event_Id is (Substitution, Foul);

   procedure Serialize (E : Binary_Event; Serialized_Obj : out JSON_Value);

   procedure Initialize (E : in out Binary_Event;
                         nEvent_Id : in Binary_Event_Id;
                         nPlayer_Id_1 : in Integer;
                         nPlayer_Id_2 : in Integer);

private

   type Binary_Event is new Game_Event with record
      Event_Id : Binary_Event_Id;
      Player_Id_1 : Integer;
      Player_Id_2 : Integer;
   end record;

end Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
