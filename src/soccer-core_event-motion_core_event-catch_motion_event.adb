
package body Soccer.Core_Event.Motion_Core_Event.Catch_Motion_Event is

   procedure Update_Serialized_Object (E : Catch_Event; Serialized_Obj : in out JSON_Value) is
   begin
      Serialized_Obj.Set_Field(Field_Name => "type_of_event",
                               Field      => "catch");
   end;

end Soccer.Core_Event.Motion_Core_Event.Catch_Motion_Event;
