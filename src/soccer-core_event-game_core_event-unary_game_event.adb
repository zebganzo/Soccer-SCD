with Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Core_Event.Game_Core_Event.Unary_Game_Event is

   procedure Serialize (E : Unary_Event; Serialized_Obj : out JSON_Value) is
   begin
      Put_Line("unary event");
      Serialized_Obj := Create_Object;
      Serialized_Obj.Set_Field(Field_Name => "event_id",
                               Field      => Unary_Event_Id'Image(E.Event_Id));
      Serialized_Obj.Set_Field(Field_Name => "player_id",
                               Field      => E.Player_Id);
   end Serialize;

end Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
