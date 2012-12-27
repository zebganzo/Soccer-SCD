package Soccer.Utils is

   --+ Distanza tra due punti
   function distance(x1 : in Integer; x2 : in Integer; y1 : in Integer; y2 : in Integer) return Integer;

   --+ Coordinate della prossima cella date le mie coordinate attuali e quelle della cella target
   function getNextCoordinate (myCoord : Coordinate; targetCoord : Coordinate_Ptr) return Coordinate;

end Soccer.Utils;
