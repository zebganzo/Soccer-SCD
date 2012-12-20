with Soccer.Field_Event;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Field_Event is

   procedure Deserialize (E : out Field_Event; Serialized_Obj : in JSON_Value) is
   begin
      Put_Line("Field_Event event");

      E.Type_Id := Field_Type_Id'Val(Serialized_Obj.Get(Field => "type_id"));
   end Deserialize;
end Soccer.Field_Event;
