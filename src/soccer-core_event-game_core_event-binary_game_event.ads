with Soccer.Core_Event.Game_Core_Event;
use Soccer.Core_Event.Game_Core_Event;
with Soccer.TeamPkg; use Soccer.TeamPkg;

package Soccer.Core_Event.Game_Core_Event.Binary_Game_Event is

   type Binary_Event is new Game_Event with private;
   type Binary_Event_Ptr is access all Binary_Event;

   type Binary_Event_Id is (Foul);

   procedure Serialize (E : Binary_Event; Serialized_Obj : out JSON_Value);

   procedure Initialize (E : in out Binary_Event;
                         new_event_id : in Binary_Event_Id;
                         new_player_1_id : in Integer;
                         new_player_1_number : Integer;
                         new_player_1_team : Team_Id;
                         new_player_2_id : Integer;
                         new_player_2_number : Integer;
                         new_player_2_team : Team_Id;
                         new_event_coord : in Coordinate);

   function Get_Event_Id (event : Binary_Event) return Binary_Event_Id;

   function Get_Id_Player_1 (event : Binary_Event) return Integer;

   function Get_Number_Player_1 (event : Binary_Event) return Integer;

   function Get_Team_Player_1 (event : Binary_Event) return Team_Id;

   function Get_Id_Player_2 (event : Binary_Event) return Integer;

   function Get_Number_Player_2 (event : Binary_Event) return Integer;

   function Get_Team_Player_2 (event : Binary_Event) return Team_Id;

   function Get_Coordinate (event : Binary_Event) return Coordinate;

private

   type Binary_Event is new Game_Event with record
      event_id : Binary_Event_Id;
      player_1_id : Integer;
      player_1_number : Integer;
      player_1_team : Team_Id;
      player_2_id : Integer;
      player_2_number : Integer;
      player_2_team : Team_Id;
      event_coord : Coordinate;
   end record;

end Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
