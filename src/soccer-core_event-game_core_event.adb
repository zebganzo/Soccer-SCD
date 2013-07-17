package body Soccer.Core_Event.Game_Core_Event is

   procedure Serialize (E : Game_Event; Serialized_Obj : out JSON_Value) is
   begin
      Serialized_Obj := Create_Object;
      Serialized_Obj.Set_Field(Field_Name => "type_of_event",
                               Field      => "game");
   end Serialize;

end Soccer.Core_Event.Game_Core_Event;
