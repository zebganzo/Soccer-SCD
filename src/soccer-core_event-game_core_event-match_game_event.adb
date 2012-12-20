with Soccer.Core_Event.Game_Core_Event.Match_Game_Event;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Core_Event.Game_Core_Event.Match_Game_Event is

   procedure Serialize (E : Match_Event; Serialized_Obj : out JSON_Value) is
   begin
      Put_Line("match event");
      Serialized_Obj := Create_Object;
      Serialized_Obj.Set_Field(Field_Name => "type_of_event",
                               Field      => "match");
      Serialized_Obj.Set_Field(Field_Name => "event_id",
                               Field      => Match_Event_Id'Image(E.Event_Id));
   end Serialize;

end Soccer.Core_Event.Game_Core_Event.Match_Game_Event;
