with Soccer.Manager_Event.Formation;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Manager_Event.Formation is

   procedure Deserialize (E : out Formation_Event; Serialized_Obj : in JSON_Value) is
   begin
      Put_Line("Formation manager event");
      E.Scheme := Formation_Scheme'Val(Serialized_Obj.Get(Field => "scheme"));
      E.Type_Id := Formation_Id;
   end Deserialize;

end Soccer.Manager_Event.Formation;
