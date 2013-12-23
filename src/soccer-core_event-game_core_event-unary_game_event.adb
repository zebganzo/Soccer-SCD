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
      Serialized_Obj.Set_Field(Field_Name => "player_team",
			       Field	  => To_String (E.event_team_id));
   end Serialize;

   function Get_Team (e : in Unary_Event_Ptr) return Team_Id is
   begin
      return e.event_team_id;
   end Get_Team;

   function Get_Player_Id (e : in Unary_Event_Ptr) return Integer is
   begin
      return e.player_id;
   end Get_Player_Id;

   function Get_Type (e : in Unary_Event_Ptr) return Unary_Event_Id is
   begin
--        Put_Line ("Event is null: " & Boolean'Image (e = null));
      return e.event_id;
   end Get_Type;

   function Get_Coordinate (e : in Unary_Event_Ptr) return Coordinate is
   begin
      return e.event_coord;
   end Get_Coordinate;

   procedure Set_Coordinate (e : in Unary_Event_Ptr; coord : in Coordinate) is
   begin
      e.event_coord := coord;
   end;

end Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
