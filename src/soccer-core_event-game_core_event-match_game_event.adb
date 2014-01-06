with Soccer.Core_Event.Game_Core_Event.Match_Game_Event;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Core_Event.Game_Core_Event.Match_Game_Event is

   procedure Initialize (e : in out Match_Event; e_id : in Match_Event_Id; p_id : in Integer) is
   begin
      e.event_id := e_id;
      e.player_id := p_id;
   end Initialize;

   procedure Serialize (E : Match_Event; Serialized_Obj : out JSON_Value) is
   begin
      Serialized_Obj := Create_Object;
      Serialized_Obj.Set_Field(Field_Name => "type_of_event",
                               Field      => "match");
      Serialized_Obj.Set_Field(Field_Name => "event_id",
			       Field      => Match_Event_Id'Image(E.event_id));
      Serialized_Obj.Set_Field(Field_Name => "player_id",
			       Field      => E.player_id);
   end Serialize;

   function Get_Match_Event_Id (e : Match_Event_Ptr) return Match_Event_Id is
   begin
      return e.event_id;
   end Get_Match_Event_Id;

   procedure Set_Kick_Off_Player (e : Match_Event_Ptr; id : Integer) is
   begin
      e.player_id := id;
   end Set_Kick_Off_Player;

   function Get_Kick_Off_Player (e : Match_Event_Ptr) return Integer is
   begin
      return e.player_id;
   end Get_Kick_Off_Player;

end Soccer.Core_Event.Game_Core_Event.Match_Game_Event;
