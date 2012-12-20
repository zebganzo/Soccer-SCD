with Soccer.Core_Event.Motion_Core_Event;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Core_Event.Motion_Core_Event is

   procedure Serialize (E : Motion_Event; Serialized_Obj : out JSON_Value) is
   begin
      Put_Line("motion event");
      Serialized_Obj := Create_Object;
      Serialized_Obj.Set_Field(Field_Name => "type_of_event",
                               Field      => "motion");
      Serialized_Obj.Set_Field(Field_Name => "player_id",
                               Field      => E.Player_Id);
      Serialized_Obj.Set_Field(Field_Name => "from_x",
                               Field      => E.From.coordX);
      Serialized_Obj.Set_Field(Field_Name => "from_y",
                               Field      => E.From.coordY);
      Serialized_Obj.Set_Field(Field_Name => "to_x",
                               Field      => E.To.coordX);
      Serialized_Obj.Set_Field(Field_Name => "to_y",
                               Field      => E.To.coordX);
   end Serialize;

end Soccer.Core_Event.Motion_Core_Event;
