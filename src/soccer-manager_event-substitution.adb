with Soccer.Manager_Event.Substitution;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Manager_Event.Substitution is

   procedure Deserialize (E : out Substitution_Event; Serialized_Obj : in JSON_Value) is
   begin
      Put_Line("substitution manager event");

      E.player_1_id := Serialized_Obj.Get(Field => "player_id_1");
      E.player_2_id := Serialized_Obj.Get(Field => "player_id_2");
      E.type_id := Substitution_Id;
   end Deserialize;

end Soccer.Manager_Event.Substitution;
