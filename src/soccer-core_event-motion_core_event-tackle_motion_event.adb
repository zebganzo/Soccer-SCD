with Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;
with Soccer.ControllerPkg; use Soccer.ControllerPkg;

package body Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event is

   function Get_Other_Player_Id (E : in Tackle_Event) return Integer is
   begin
      return E.Other_Player_Id;
   end Get_Other_Player_Id;

   procedure Set_Other_Player_Id (E : in out Tackle_Event; id : in Integer) is
   begin
      E.Other_Player_Id := id;
   end Set_Other_Player_Id;

   procedure Update_Serialized_Object (E : Tackle_Event; Serialized_Obj : in out JSON_Value) is
   begin
      Serialized_Obj.Set_Field(Field_Name => "type_of_event",
                               Field      => "tackle");
      Serialized_Obj.Set_Field(Field_Name => "other_player_id",
			       Field      => E.Other_Player_Id);
      Serialized_Obj.Set_Field (Field_Name => "other_player_number",
				Field	   => I2S (ControllerPkg.Get_Number_From_Id (E.Other_Player_Id)));
   end;

end Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;
