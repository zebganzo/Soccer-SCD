with Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Core_Event.Game_Core_Event.Binary_Game_Event is

   procedure Serialize (E : Binary_Event; Serialized_Obj : out JSON_Value) is
   begin
      Put_Line("binary event");
      Serialized_Obj := Create_Object;
      Serialized_Obj.Set_Field(Field_Name => "type_of_event",
                               Field      => "binary");
      Serialized_Obj.Set_Field(Field_Name => "event_id",
                               Field      => Binary_Event_Id'Image(E.Event_Id));
      Serialized_Obj.Set_Field(Field_Name => "player_id_1",
                               Field      => E.Player_Id_1);
      Serialized_Obj.Set_Field(Field_Name => "player_id_2",
                               Field      => E.Player_Id_2);
   end Serialize;

end Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
