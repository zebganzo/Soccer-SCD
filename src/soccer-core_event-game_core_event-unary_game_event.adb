with Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Core_Event.Game_Core_Event.Unary_Game_Event is

   procedure Initialize (E : in out Unary_Event; nEvent_Id : in Unary_Event_Id; nPlayer_Id : in Integer) is
   begin
      E.Event_Id := nEvent_Id;
      E.Player_Id := nPlayer_Id;
   end Initialize;

   procedure Serialize (E : Unary_Event; Serialized_Obj : out JSON_Value) is
   begin
      Put_Line("unary event");
      Serialized_Obj := Create_Object;
            Serialized_Obj.Set_Field(Field_Name => "type_of_event",
                               Field      => "unary");
      Serialized_Obj.Set_Field(Field_Name => "event_id",
                               Field      => Unary_Event_Id'Image(E.Event_Id));
      Serialized_Obj.Set_Field(Field_Name => "player_id",
                               Field      => E.Player_Id);
   end Serialize;

end Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
