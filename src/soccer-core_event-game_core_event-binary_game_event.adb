with Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Core_Event.Game_Core_Event.Binary_Game_Event is

   procedure Initialize (E : in out Binary_Event;
                         new_event_id : in Binary_Event_Id;
                         new_player_1_id : in Integer;
			 new_player_2_id : in Integer;
			 new_event_coord : in Coordinate) is
   begin
      E.event_id := new_event_id;
      E.player_1_id := new_player_1_id;
      E.player_2_id := new_player_2_id;
      E.event_coord := new_event_coord;
   end Initialize;

   procedure Serialize (E : Binary_Event; Serialized_Obj : out JSON_Value) is
   begin
      Put_Line("binary event");
      Serialized_Obj := Create_Object;
      Serialized_Obj.Set_Field(Field_Name => "type_of_event",
                               Field      => "binary");
      Serialized_Obj.Set_Field(Field_Name => "event_id",
                               Field      => Binary_Event_Id'Image(E.event_id));
      Serialized_Obj.Set_Field(Field_Name => "player_1_id",
                               Field      => E.player_1_id);
      Serialized_Obj.Set_Field(Field_Name => "player_2_id",
			       Field      => E.player_2_id);
      Serialized_Obj.Set_Field(Field_Name => "event_coord",
                               Field      => Serialize_Coordinate (E.event_coord) );
   end Serialize;

   function Get_Event_Id (event : Binary_Event) return Binary_Event_Id is
   begin
      return event.event_id;
   end Get_Event_Id;

end Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
