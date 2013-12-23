with Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Core_Event.Game_Core_Event.Binary_Game_Event is

   procedure Initialize (E : in out Binary_Event;
                         new_event_id : in Binary_Event_Id;
                         new_player_1_id : in Integer;
                         new_player_1_number : Integer;
                         new_player_1_team : Team_Id;
                         new_player_2_id : Integer;
                         new_player_2_number : Integer;
                         new_player_2_team : Team_Id;
                         new_event_coord : in Coordinate) is
   begin
      E.event_id := new_event_id;
      E.player_1_id := new_player_1_id;
      E.player_1_number := new_player_1_number;
      E.player_1_team := new_player_1_team;
      E.player_2_id := new_player_2_id;
      E.player_2_number := new_player_2_number;
      E.player_2_team := new_player_2_team;
      E.event_coord := new_event_coord;
   end Initialize;

   procedure Serialize (E : Binary_Event; Serialized_Obj : out JSON_Value) is
   begin

      Serialized_Obj := Create_Object;
      Serialized_Obj.Set_Field(Field_Name => "type_of_event",
                               Field      => "binary");
      Serialized_Obj.Set_Field(Field_Name => "event_id",
                               Field      => Binary_Event_Id'Image(E.event_id));
      Serialized_Obj.Set_Field(Field_Name => "player_1_id",
                               Field      => E.player_1_id);
      Serialized_Obj.Set_Field(Field_Name => "player_1_number",
                               Field      => E.player_1_number);
      Serialized_Obj.Set_Field(Field_Name => "player_1_team",
                               Field      => Team_Id'Image(E.player_1_team));
      Serialized_Obj.Set_Field(Field_Name => "player_2_id",
                               Field      => E.player_2_id);
      Serialized_Obj.Set_Field(Field_Name => "player_2_number",
                               Field      => E.player_2_number);
      Serialized_Obj.Set_Field(Field_Name => "player_2_team",
			       Field      => Team_Id'Image(E.player_2_team));
      Serialized_Obj.Set_Field(Field_Name => "event_coord_x",
			       Field	  => E.event_coord.coord_x);
      Serialized_Obj.Set_Field(Field_Name => "event_coord_y",
			       Field	  => E.event_coord.coord_y);
   end Serialize;

   function Get_Event_Id (event : Binary_Event) return Binary_Event_Id is
   begin
      return event.event_id;
   end Get_Event_Id;


   function Get_Id_Player_1 (event : Binary_Event) return Integer is
   begin
      return event.player_1_id;
   end;

   function Get_Number_Player_1 (event : Binary_Event) return Integer is
   begin
      return event.player_1_number;
   end;

   function Get_Team_Player_1 (event : Binary_Event) return Team_Id is
   begin
      return event.player_1_team;
   end;

   function Get_Id_Player_2 (event : Binary_Event) return Integer is
   begin
      return event.player_2_id;
   end;

   function Get_Number_Player_2 (event : Binary_Event) return Integer is
   begin
      return event.player_2_number;
   end;

   function Get_Team_Player_2 (event : Binary_Event) return Team_Id is
   begin
      return event.player_2_team;
   end;

   function Get_Coordinate (event : Binary_Event) return Coordinate is
   begin
      return event.event_coord;
   end Get_Coordinate;

end Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
