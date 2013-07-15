with Soccer.Core_Event.Game_Core_Event;
use Soccer.Core_Event.Game_Core_Event;

package Soccer.Core_Event.Game_Core_Event.Binary_Game_Event is

   type Binary_Event is new Game_Event with private;
   type Binary_Event_Prt is access all Binary_Event;

   type Binary_Event_Id is (Foul);

   procedure Serialize (E : Binary_Event; Serialized_Obj : out JSON_Value);

   procedure Initialize (E : in out Binary_Event;
                         new_event_id : in Binary_Event_Id;
                         new_player_1_id : in Integer;
			 new_player_2_id : in Integer;
			 new_event_coord : in Coordinate);

   function Get_Event_Id (event : Binary_Event) return Binary_Event_Id;

private

   type Binary_Event is new Game_Event with record
      event_id : Binary_Event_Id;
      player_1_id : Integer;
      player_2_id : Integer;
      event_coord : Coordinate;
   end record;

end Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
