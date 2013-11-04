with Soccer.Manager_Event.Substitution;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Manager_Event.Substitution is

   procedure Initialize (e : in out Substitution_Event_Ptr; team : Team_Id; id_1 : Integer; id_2 : Integer) is
   begin
      e.team := team;
      e.player_1_id := id_1;
      e.player_2_id := id_2;
   end Initialize;

   procedure Set_Correct_Ids (e : Substitution_Event_Ptr; id_1 : Integer; id_2 : Integer) is
   begin
      e.player_1_id := id_1;
      e.player_2_id := id_2;
   end;

   procedure Get_Numbers (e : in Substitution_Event_Ptr; id_1 : out Integer; id_2 : out Integer) is
   begin
      id_1 := e.player_1_id;
      id_2 := e.player_2_id;
   end Get_Numbers;

   procedure Deserialize (E : out Substitution_Event; Serialized_Obj : in JSON_Value) is
      team : String := Serialized_Obj.Get (Field => "team");
   begin
      Put_Line("substitution manager event");

      if team = "Team_One" then
	 E.team := Team_One;
      else
	 E.team := Team_Two;
      end if;

      E.player_1_id := Serialized_Obj.Get (Field => "player_id_1");
      E.player_2_id := Serialized_Obj.Get (Field => "player_id_2");
      E.type_id := Substitution_Id;
   end Deserialize;

end Soccer.Manager_Event.Substitution;
