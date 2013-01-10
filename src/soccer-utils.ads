package Soccer.Utils is

   --+ Distanza tra due punti
   function Distance(x1 : in Integer; x2 : in Integer; y1 : in Integer; y2 : in Integer) return Integer;

   --+ Distanza tra due punti
   function Distance(From : in Coordinate; To : in Coordinate) return Integer;

   --+ Coordinate della prossima cella date le mie coordinate attuali e quelle della cella target
   function Get_Next_Coordinate (myCoord : Coordinate; targetCoord : Coordinate) return Coordinate;

   function Get_Ball_Delay (power : Power_Range) return duration;

   function Compare_Coordinates (coord1 : Coordinate; coord2 : Coordinate) return Boolean;

   function Get_Random_Target (coord : Coordinate) return Coordinate;

   procedure CLS;

   function Check_Inside_Field (coord: Coordinate) return Boolean;

end Soccer.Utils;
