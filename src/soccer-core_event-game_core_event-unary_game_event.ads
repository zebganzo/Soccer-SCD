with Soccer.Core_Event.Game_Core_Event;
use Soccer.Core_Event.Game_Core_Event;
with Soccer.TeamPkg; use Soccer.TeamPkg;

package Soccer.Core_Event.Game_Core_Event.Unary_Game_Event is

   type Unary_Event is new Game_Event with private;
   type Unary_Event_Ptr is access all Unary_Event;
   type Unary_Event_Id is (Goal,
--  			   Send_Off,
--  			   Caution,
                           Goal_Kick,
                           Corner_Kick,
                           Penalty_Kick,
			   Throw_In,
			   Free_Kick);
--  			   Kick_Off);

   procedure Serialize (E : Unary_Event; Serialized_Obj : out JSON_Value);

   procedure Initialize (E : in out Unary_Event;
			 new_event_id : in Unary_Event_Id;
			 new_player_id : in Integer;
			 new_team_id : in Team_Id;
			 new_event_coord : in Coordinate);

   function Get_Team (e : in Unary_Event_Ptr) return Team_Id;
   function Get_Player_Id (e : in Unary_Event_Ptr) return Integer;
   function Get_Type (e : in Unary_Event_Ptr) return Unary_Event_Id;
   function Get_Coordinate (e : in Unary_Event_Ptr) return Coordinate;
   procedure Set_Coordinate (e : in Unary_Event_Ptr; coord : in Coordinate);

private

   type Unary_Event is new Game_Event with record
      event_id : Unary_Event_Id;
      player_id : Integer;
      event_team_id : Team_Id;
      event_coord : Coordinate;
   end record;

end Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
