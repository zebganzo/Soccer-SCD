with Soccer.Manager_Event.Substitution;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Manager_Event.Substitution is

   procedure Deserialize (E : out Substitution_Event; Serialized_Obj : in JSON_Value) is
   begin
      Put_Line("substitution manager event");

      E.Player_Id_1 := Serialized_Obj.Get(Field => "player_id_1");
      E.Player_Id_2 := Serialized_Obj.Get(Field => "player_id_2");
      E.Type_Id := Substitution_Id;
   end Deserialize;

end Soccer.Manager_Event.Substitution;
