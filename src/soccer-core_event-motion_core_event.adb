with Soccer.Core_Event.Motion_Core_Event;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Core_Event.Motion_Core_Event is

   function Get_Player_Id (E : in Motion_Event) return Integer is
   begin
      return E.Player_Id;
   end Get_Player_Id;

   function Get_Player_Number (E : in Motion_Event) return Integer is
   begin
      return E.Player_Number;
   end Get_Player_Number;

   function Get_Player_Team (E : in Motion_Event) return Team_Id is
   begin
      return E.Player_Team;
   end Get_Player_Team;

   function Get_From (E : in Motion_Event) return Coordinate is
   begin
      return E.From;
   end Get_From;

   function Get_To (E : in Motion_Event) return Coordinate is
   begin
      return E.To;
   end Get_To;

   procedure Initialize (E : in out Motion_Event;
                         nPlayer_Id : in Integer;
                         nPlayer_Number : In Integer;
                         nPlayer_Team : in Team_Id;
                         nFrom : in Coordinate;
                         nTo : in Coordinate) is
   begin
      E.Player_Id := nPlayer_Id;
      E.Player_Number := nPlayer_Number;
      E.Player_Team := nPlayer_Team;
      E.From := nFrom;
      E.To := nTo;
   end Initialize;

   procedure Serialize (E : Motion_Event; Serialized_Obj : out JSON_Value) is

   begin
      Serialized_Obj := Create_Object;
      Serialized_Obj.Set_Field(Field_Name => "player_id",
                               Field      => E.Player_Id);
      Serialized_Obj.Set_Field(Field_Name => "player_number",
                               Field      => E.Player_Number);
      Serialized_Obj.Set_Field(Field_Name => "player_team",
                               Field      => Team_Id'Image(E.Player_Team));
      Serialized_Obj.Set_Field(Field_Name => "from_x",
                               Field      => E.From.coord_x);
      Serialized_Obj.Set_Field(Field_Name => "from_y",
                               Field      => E.From.coord_y);
      Serialized_Obj.Set_Field(Field_Name => "to_x",
                               Field      => E.To.coord_x);
      Serialized_Obj.Set_Field(Field_Name => "to_y",
                               Field      => E.To.coord_x);
   end Serialize;

end Soccer.Core_Event.Motion_Core_Event;
