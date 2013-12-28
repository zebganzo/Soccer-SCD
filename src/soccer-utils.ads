with Soccer.TeamPkg; use Soccer.TeamPkg;
with Soccer.Core_Event.Game_Core_Event; use Soccer.Core_Event.Game_Core_Event;
package Soccer.Utils is

   --+ Distanza tra due punti
   function Distance(x1 : in Integer; x2 : in Integer; y1 : in Integer; y2 : in Integer) return Integer;

   --+ Distanza tra due punti
   function Distance(From : in Coordinate; To : in Coordinate) return Integer;

   --+ Coordinate della prossima cella date le mie coordinate attuali e quelle della cella target
   function Get_Next_Coordinate (myCoord : Coordinate; targetCoord : Coordinate) return Coordinate;

   function NEW_Get_Next_Coordinate (start_coord : Coordinate; target_coord : Coordinate) return Coordinate;

   --+ Mi tolgo di mezzo nel caso di gioco fermo
   function Back_Off (current_coord : Coordinate; reference_coord : Coordinate; event_coord : Coordinate) return Coordinate;

   function Get_Ball_Delay (power : Power_Range) return duration;

   function Compare_Coordinates (coord1 : Coordinate; coord2 : Coordinate) return Boolean;

   function Get_Random_Target (coord : Coordinate) return Coordinate;

   procedure CLS;

   function Check_Inside_Field (coord: Coordinate) return Boolean;

   function Is_In_Penalty_Area (team : Team_Id; coord : Coordinate) return Boolean;

   function Print_Coord (coord : Coordinate) return String;

   function Is_Match_Event (event : Game_Event_Ptr) return Boolean;

--     function Time_Image_Two (Item : in Ada.Calendar.Time) return String;

--     function Get_Nearest_Player (point_coord : Coordinate; team : Team_Id) return Integer;

end Soccer.Utils;
