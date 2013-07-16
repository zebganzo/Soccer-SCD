with Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Core_Event.Game_Core_Event.Unary_Game_Event is

   procedure Initialize (E : in out Unary_Event;
			 new_event_id : in Unary_Event_Id;
			 new_player_id : in Integer;
			 new_team_id : in Team_Id;
			 new_event_coord : in Coordinate) is
   begin
      E.event_id := new_event_id;
      E.player_id := new_player_id;
      E.event_team_id := new_team_id;
      E.event_coord := new_event_coord;
   end Initialize;

   procedure Serialize (E : Unary_Event; Serialized_Obj : out JSON_Value) is
   begin
      Put_Line("unary event");

      Serialized_Obj := Create_Object;
      Serialized_Obj.Set_Field(Field_Name => "type_of_event",
                               Field      => "unary");
      Serialized_Obj.Set_Field(Field_Name => "event_id",
                               Field      => Unary_Event_Id'Image(E.event_id));
      Serialized_Obj.Set_Field(Field_Name => "player_id",
			       Field      => E.player_id);
      Serialized_Obj.Set_Field(Field_Name => "team_id",
			       Field	  => To_String (E.event_team_id));
   end Serialize;

end Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
