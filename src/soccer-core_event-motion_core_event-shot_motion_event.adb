with Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event;

package body Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event is

   procedure Set_Shot_Power (E : in out Shot_Event; power : Power_Range) is
   begin
      E.Shot_Power := power;
   end Set_Shot_Power;

   function Get_Shot_Power (E : in Shot_Event) return Power_Range is
   begin
      return E.Shot_Power;
   end Get_Shot_Power;

   procedure Update_Serialized_Object (E : Shot_Event; Serialized_Obj : in out JSON_Value) is
   begin
      Serialized_Obj.Set_Field(Field_Name => "type_of_event",
                               Field      => "shot");
   end;

end Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event;
