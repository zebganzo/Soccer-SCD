with Soccer.Core_Event.Game_Core_Event;
use Soccer.Core_Event.Game_Core_Event;

package Soccer.Core_Event.Game_Core_Event.Match_Game_Event is

   type Match_Event is new Game_Event with private;
   type Match_Event_Ptr is access all Match_Event;

   type Match_Event_Id is (Begin_Of_Match,
			   End_Of_First_Half,
			   Begin_Of_Second_Half,
			   End_Of_Match);

   procedure Serialize (E : Match_Event; Serialized_Obj : out JSON_Value);

   procedure Initialize (e : in out Match_Event; e_id : in Match_Event_Id; p_id : in Integer);

   function Get_Match_Event_Id (e : Match_Event_Ptr) return Match_Event_Id;

   procedure Set_Kick_Off_Player (e : Match_Event_Ptr; id : Integer);

   function Get_Kick_Off_Player (e : Match_Event_Ptr) return Integer;

private

   type Match_Event is new Game_Event with record
      event_id : Match_Event_Id;
      player_id : Integer;
   end record;

end Soccer.Core_Event.Game_Core_Event.Match_Game_Event;
