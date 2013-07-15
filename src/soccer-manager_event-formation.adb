with Soccer.Manager_Event.Formation;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Manager_Event.Formation is

   procedure Deserialize (E : out Formation_Event; Serialized_Obj : in JSON_Value) is
   begin
      Put_Line("Formation manager event");
      E.Scheme := Formation_Scheme'Val(Serialized_Obj.Get(Field => "scheme"));
      E.type_id := Formation_Id;
   end Deserialize;

   function Get_Scheme (E : in Formation_Event) return Formation_Scheme is
   begin
      return E.Scheme;
   end Get_Scheme;


end Soccer.Manager_Event.Formation;
