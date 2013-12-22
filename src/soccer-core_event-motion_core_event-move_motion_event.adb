with Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;

package body Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event is

   procedure Update_To_Coordinate (E : in out Move_Event; new_coord : in Coordinate) is
   begin
      E.To := new_coord;
   end Update_To_Coordinate;

   procedure Update_Serialized_Object (E : Move_Event; Serialized_Obj : in out JSON_Value) is
   begin
      Serialized_Obj.Set_Field(Field_Name => "type_of_event",
			       Field      => "move");
   end;

end Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;
