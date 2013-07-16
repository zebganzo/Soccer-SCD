with Soccer.Core_Event.Game_Core_Event;
use Soccer.Core_Event.Game_Core_Event;
with Soccer.TeamPkg; use Soccer.TeamPkg;

package Soccer.Core_Event.Game_Core_Event.Unary_Game_Event is

   type Unary_Event is new Game_Event with private;
   type Unary_Event_Prt is access all Unary_Event;
   type Unary_Event_Id is (Send_Off,
			   Caution,
			   Goal,
			   Throw_In,
			   Goal_Kick,
			   Corner_Kick,
			   Free_Kick,
			   Penalty_Kick);

   procedure Serialize (E : Unary_Event; Serialized_Obj : out JSON_Value);

   procedure Initialize (E : in out Unary_Event;
			 new_event_id : in Unary_Event_Id;
			 new_player_id : in Integer;
			 new_team_id : in Team_Id;
			 new_event_coord : in Coordinate);

private

   type Unary_Event is new Game_Event with record
      event_id : Unary_Event_Id;
      player_id : Integer;
      event_team_id : Team_Id;
      event_coord : Coordinate;
   end record;

end Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
